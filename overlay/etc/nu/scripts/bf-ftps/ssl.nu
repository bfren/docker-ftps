use bf

# Return the arguments for openssl to create a self-signed certificate, with its key, in one file
export def cert_args [
    file: string    # Path to the certificate file
    bits: any       # Size of the RSA key in bits
]: nothing -> list<string> {
    [
        "req"
        "-newkey" $"rsa:($bits)"
        "-x509"
        "-sha256"
        "-days" "3650"
        "-nodes"
        "-out" $file
        "-keyout" $file
        "-subj" "/C=NA/ST=NA/L=NA/O=NA/OU=NA/CN=vsftpd"
    ]
}

# Create a self-signed certificate, with its key, in one file
export def create_cert [
    file: string    # Path to the certificate file
    bits: any       # Size of the RSA key in bits
]: nothing -> nothing {
    { ^openssl ...(cert_args $file $bits) } | bf handle -I ssl/create_cert
}
