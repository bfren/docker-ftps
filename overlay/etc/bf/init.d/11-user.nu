use bf
use bf-ftps
bf env load

# Create FTP user account if it does not already exit
def main [] {
    # ensure the user, password and external address are set
    let errors = bf-ftps checks environment
    if ($errors | is-not-empty) {
        $errors | each {|x| bf write notok $x } | ignore
        bf write error "The FTPS server cannot be configured - see above."
    }

    # get variables
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
    { $"($pass)\n($pass)" | ^adduser -h $files -s /sbin/nologin -u $uid $name } | bf handle

    # apply permissions
    bf write $"Ensuring user ($name) owns ($files)."
    bf ch --owner $"($name):($name)" --recurse $files

    # return nothing
    return
}
