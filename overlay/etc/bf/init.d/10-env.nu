use bf
bf env load

# Set environment variables
def main [] {
    # volumes
    let ssl = "/ssl"
    bf env set FTPS_FILES "/files"
    bf env set FTPS_SSL $ssl

    # vsftp
    let etc = "/etc/vsftpd"
    bf env set FTPS_VSFTPD_CERT $"($ssl)/vsftpd.pem"
    bf env set FTPS_VSFTPD_CONF $"($etc)/vsftpd.conf"
    bf env set FTPS_VSFTP_ETC $etc
    bf env set FTPS_VSFTPD_LOG_FILE "/var/log/vsftpd.log"

    # lftp
    bf env set FTPS_LFTP_CONF "/etc/lftp.conf"

    # return nothing
    return
}
