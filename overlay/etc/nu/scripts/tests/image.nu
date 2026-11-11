use std/assert
use bf


#======================================================================================================================
# installation
#======================================================================================================================

export def install__vsftpd_matches_build [] {
    let build = with-env {BF_ETC: "/etc/bf"} { bf build | get vsftpd }
    # vsftpd writes its version to file descriptor 0 (stdin), so redirect that to stdout
    let installed = ^sh -c "vsftpd -v 0>&1" | complete | get stdout | parse --regex '(?<v>\d+\.\d+\.\d+)' | get v.0

    assert ($build | str starts-with $installed) $"vsftpd ($installed) should match the build ($build)"
}

export def install__tools_are_installed [] {
    for x in [vsftpd lftp openssl] {
        assert (which $x | is-not-empty) $"($x) should be installed"
    }
}

export def install__ssl_directory_is_linked [] {
    assert equal "/ssl" (^readlink /etc/ssl/private | str trim)
}

export def install__vsftpd_user_has_low_ids [] {
    let user = open /etc/passwd | lines | split column ":" name x uid gid | where name == "vsftpd"

    assert equal 1 ($user | length) "the vsftpd user should exist"
    # user namespaces such as Podman's UserNS=auto may map only the first 1024 ids
    assert (($user.0.uid | into int) < 1000) "the vsftpd uid should be below 1000"
    assert (($user.0.gid | into int) < 1000) "the vsftpd gid should be below 1000"
}


#======================================================================================================================
# scripts
#======================================================================================================================

export def scripts__parse [] {
    let paths = [
        "/etc/bf/health.d/10-vsftpd.nu"
        "/etc/s6-overlay/s6-rc.d/vsftpd/run"
        "/etc/s6-overlay/s6-rc.d/vsftpd-log/run"
        "/etc/bf/init.d/11-user.nu"
        "/etc/bf/init.d/13-vsftpd-ssl.nu"
    ]
    for path in $paths {
        let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($path)" | complete
        assert equal "true" ($result.stdout | str trim) $"($path) does not parse: ($result.stderr)"
    }
}
