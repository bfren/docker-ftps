use bf

# Output the last 50 lines of the FTPS log and then tail it
export def main [] {
    let log = bf env FTPS_VSFTPD_LOG_FILE
    bf fs read $log | lines | last 50
    ^exec tail -f $log
}
