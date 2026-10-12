use bf
use bf-s6
bf env load

# Generate vsftpd configuration file
def main [] {
    # at least one of external URI or IP must be defined
    let uri = bf env --safe FTPS_EXTERNAL_URI
    let ip = bf env --safe FTPS_EXTERNAL_IP
    if $uri == "" and $ip == "" {
        bf write error "You must provide either BF_FTPS_EXTERNAL_URI or BF_FTPS_EXTERNAL_IP."
    }

    # generate configuration file
    bf write "Generating vsftpd configuration."
    bf-s6 esh template (bf env FTPS_VSFTPD_CONF)
}
