use bf
bf env load

# Create FTP user account if it does not already exit
def main [] {
    # ensure user and pass are set
    let name = bf env FTPS_VSFTPD_USER
    let pass = bf env FTPS_VSFTPD_PASS
    let uid = bf env FTPS_VSFTPD_UID 1000

    # if the user already exists, return
    if (bf user exists $name) {
        bf write $"User ($name) already exists."
        return
    }

    # create the user
    let files = bf env FTPS_FILES
    bf write $"Creating user ($name)."
    { ^echo -e $"($pass)\n($pass)" | ^adduser -h $files -s /sbin/nologin -u $uid $name } | bf handle

    # apply permissions
    bf write $"Ensuring user ($name) owns ($files)."
    bf ch --owner $"($name):($name)" --recurse $files

    # return nothing
    return
}
