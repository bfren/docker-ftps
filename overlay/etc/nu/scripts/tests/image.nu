use std/assert
use bf


#======================================================================================================================
# installation
#======================================================================================================================

export def install__vsftpd_matches_build [] {
    let build = with-env {BF_ETC: "/etc/bf"} { bf build | get vsftpd }
    let installed = ^vsftpd -v | complete | $in.stdout + $in.stderr | parse --regex '(?<v>\d+\.\d+\.\d+)' | get v.0

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


#======================================================================================================================
# scripts
#======================================================================================================================

export def scripts__parse [] {
    let paths = [
        "/usr/bin/bf/bf-healthcheck"
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
