use std/assert
use bf-ftps


#======================================================================================================================
# environment
#======================================================================================================================

# Environment with everything required set
def valid []: nothing -> record {
    {BF_FTPS_VSFTPD_USER: "fred", BF_FTPS_VSFTPD_PASS: "secret", BF_FTPS_EXTERNAL_IP: "203.0.113.1"}
}

export def environment__passes_when_everything_is_set [] {
    assert equal [] (with-env (valid) { bf-ftps checks environment })
}

export def environment__accepts_uri_instead_of_ip [] {
    let vars = valid | reject BF_FTPS_EXTERNAL_IP | insert BF_FTPS_EXTERNAL_URI "ftp.example.com"

    assert equal [] (with-env $vars { bf-ftps checks environment })
}

export def environment__reports_missing_user_and_password [] {
    let result = with-env (valid | reject BF_FTPS_VSFTPD_USER BF_FTPS_VSFTPD_PASS) { bf-ftps checks environment }

    assert equal ["BF_FTPS_VSFTPD_USER must be set." "BF_FTPS_VSFTPD_PASS must be set."] $result
}

export def environment__reports_missing_address [] {
    let result = with-env (valid | reject BF_FTPS_EXTERNAL_IP) { bf-ftps checks environment }

    assert equal 1 ($result | length)
    assert ($result.0 =~ "BF_FTPS_EXTERNAL_URI or BF_FTPS_EXTERNAL_IP")
}


#======================================================================================================================
# cert
#======================================================================================================================

export def cert__passes_when_file_has_contents [] {
    let file = mktemp
    "PEM" | save --force $file

    let result = bf-ftps checks cert $file

    rm $file
    assert equal "" $result
}

export def cert__waits_for_empty_file [] {
    let file = mktemp

    let result = bf-ftps checks cert $file

    rm $file
    assert ($result =~ "is empty")
}

export def cert__reports_directory [] {
    let dir = mktemp --directory

    let result = bf-ftps checks cert $dir

    rm --recursive $dir
    assert ($result =~ "is a directory")
}

export def cert__reports_missing_file [] {
    assert ((bf-ftps checks cert "/tmp/does-not-exist.pem") =~ "does not exist")
}
