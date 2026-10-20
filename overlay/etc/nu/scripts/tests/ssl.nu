use std/assert
use bf-ftps


#======================================================================================================================
# certificate
#======================================================================================================================

export def cert_args__use_bits_and_one_file [] {
    let args = bf-ftps ssl cert_args "/ssl/vsftpd.pem" 2048

    assert ("rsa:2048" in $args)
    assert equal "/ssl/vsftpd.pem" ($args | get (($args | enumerate | where item == "-out" | get index.0) + 1))
    assert equal "/ssl/vsftpd.pem" ($args | get (($args | enumerate | where item == "-keyout" | get index.0) + 1))
}

export def create_cert__creates_certificate_and_key_in_one_file [] {
    let file = $"(mktemp --directory)/vsftpd.pem"
    bf-ftps ssl create_cert $file 2048
    let pem = open --raw $file

    assert ($pem =~ "BEGIN CERTIFICATE") "the file should contain the certificate"
    assert ($pem =~ "BEGIN PRIVATE KEY") "the file should contain the key"
    assert ((^openssl x509 -noout -subject -in $file) =~ "CN ?= ?vsftpd")
}

export def create_cert__lasts_ten_years [] {
    let file = $"(mktemp --directory)/vsftpd.pem"
    bf-ftps ssl create_cert $file 2048
    let result = ^openssl x509 -noout -checkend (3649 * 86400) -in $file | complete

    assert equal 0 $result.exit_code "the certificate should still be valid in 3649 days"
}
