use bf
use bf-s6
bf env load

# Generate vsftpd configuration file (the environment is checked by 11-user.nu)
def main [] {
    bf write "Generating vsftpd configuration."
    bf-s6 esh template (bf env FTPS_VSFTPD_CONF)
}
