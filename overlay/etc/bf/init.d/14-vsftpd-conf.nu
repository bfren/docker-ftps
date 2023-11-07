use bf
bf env load

# Generate vsftpd configuration file
def main [] {
    # at least one of external URI or IP must be defined
    let uri = bf env safe FTPS_EXTERNAL_URI
    let ip = bf env safe FTPS_EXTERNAL_IP
    if $uri == null and $ip == null {
        bf write error "You must provide either BF_FTPS_EXTERNAL_URI or BF_FTPS_EXTERNAL_IP."
    }

    # generate configuration file
    bf write "Generating vsftpd configuration."
    bf esh template (bf env FTPS_VSFTPD_CONF)
}
