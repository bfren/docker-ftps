use bf
bf env load

# Create an SSL certificate if one does not already exist
def main [] {
    # if an SSL certificate already exists, return
    let cert = bf env FTPS_VSFTPD_CERT
    if ($cert | path exists) {
        bf write "SSL certificate already exists."
        return
    }

    # create SSL certificate and key
    bf write "Creating SSL certificate and key."
    let bits = bf env FTPS_SSL_BITS
    let subj = "/C=NA/ST=NA/L=NA/O=NA/OU=NA/CN=vsftpd"
    let args = [
        $"-newkey rsa:($bits)"
        "-x509"
        "-sha256"
        "-days 3650"
        "-nodes"
        $"-out ($cert)"
        $"-keyout ($cert)"
        $"-subj \"($subj)\""
    ] | str join " "
    { ^sh -c $"openssl req ($args)" } | bf handle
}
