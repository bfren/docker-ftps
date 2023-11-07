use bf
bf env load

# Create a blank log file
def main [] {
    # create log file
    bf write "Creating log file."
    let file = (bf env FTPS_VSFTPD_LOG_FILE)
    touch $file

    # set permissions
    bf ch --mode 0666 $file
}
