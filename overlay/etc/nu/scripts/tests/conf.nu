use std/assert


#======================================================================================================================
# helpers
#======================================================================================================================

# Generate a configuration file from its template in a temporary directory, with $vars added to (and overriding) the
# defaults set in the Dockerfile and 10-env.nu, and return its lines without comments or blank lines
def render [name: string, vars: record = {}]: nothing -> list<string> {
    let file = $"(mktemp --directory)/($name)"
    let defaults = {
        BF_FTPS_FILES: "/files"
        BF_FTPS_VSFTPD_CERT: "/ssl/vsftpd.pem"
        BF_FTPS_VSFTPD_LOG_FILE: "/var/log/vsftpd.log"
        BF_FTPS_VSFTPD_USER: "fred"
        BF_FTPS_VSFTPD_WELCOME: "Welcome to the FTPS server."
        BF_FTPS_VSFTPD_MIN_PORT: "18700"
        BF_FTPS_VSFTPD_MAX_PORT: "18710"
        BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG: "0"
        BF_FTPS_VSFTPD_ENABLE_PASV_PROMISCUOUS: "0"
        BF_FTPS_EXTERNAL_IP: "203.0.113.1"
        BF_FTPS_LFTP_VERIFY_CERT: "no"
    }
    let result = with-env ($defaults | merge $vars) { ^esh -o $file $"/etc/bf/templates/($name).esh" | complete }
    assert equal 0 $result.exit_code $"the template should render: ($result.stderr)"
    open --raw $file | lines | str trim | where {|x| $x != "" and not ($x starts-with "#") }
}


#======================================================================================================================
# vsftpd.conf
#======================================================================================================================

export def vsftpd__requires_tls_for_logins_and_data [] {
    let conf = render vsftpd.conf

    for x in ["ssl_enable=YES" "force_local_logins_ssl=YES" "force_local_data_ssl=YES" "anonymous_enable=NO" "rsa_cert_file=/ssl/vsftpd.pem"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def vsftpd__keeps_users_in_files_directory [] {
    let conf = render vsftpd.conf

    assert ("chroot_local_user=YES" in $conf)
    assert ("local_root=/files" in $conf)
}

export def vsftpd__uses_ip_for_passive_mode [] {
    let conf = render vsftpd.conf

    assert ("pasv_address=203.0.113.1" in $conf)
    assert not ("pasv_addr_resolve=YES" in $conf)
    assert ("pasv_min_port=18700" in $conf)
    assert ("pasv_max_port=18710" in $conf)
}

export def vsftpd__prefers_uri_for_passive_mode [] {
    let conf = render vsftpd.conf {BF_FTPS_EXTERNAL_URI: "ftp.example.com"}

    assert ("pasv_address=ftp.example.com" in $conf)
    assert ("pasv_addr_resolve=YES" in $conf)
    assert not ("pasv_address=203.0.113.1" in $conf)
}

export def vsftpd__uses_port_range_and_welcome [] {
    let conf = render vsftpd.conf {BF_FTPS_VSFTPD_MIN_PORT: "30000", BF_FTPS_VSFTPD_MAX_PORT: "30009", BF_FTPS_VSFTPD_WELCOME: "Hello"}

    for x in ["pasv_min_port=30000" "pasv_max_port=30009" "ftpd_banner=Hello"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def vsftpd__logs_only_when_enabled [] {
    assert ("xferlog_enable=NO" in (render vsftpd.conf))
    assert ("xferlog_enable=YES" in (render vsftpd.conf {BF_FTPS_VSFTPD_ENABLE_DEBUG_LOG: "1"}))
}

export def vsftpd__passive_promiscuous_only_when_enabled [] {
    assert not ("pasv_promiscuous=yes" in (render vsftpd.conf))
    assert ("pasv_promiscuous=yes" in (render vsftpd.conf {BF_FTPS_VSFTPD_ENABLE_PASV_PROMISCUOUS: "1"}))
}


#======================================================================================================================
# lftp.conf
#======================================================================================================================

export def lftp__uses_certificate_verification_setting [] {
    assert ("set ssl:verify-certificate no" in (render lftp.conf))
    assert ("set ssl:verify-certificate yes" in (render lftp.conf {BF_FTPS_LFTP_VERIFY_CERT: "yes"}))
}
