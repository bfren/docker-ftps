use bf
use bf-ftps
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
    bf-ftps ssl create_cert $cert (bf env FTPS_SSL_BITS)
}
