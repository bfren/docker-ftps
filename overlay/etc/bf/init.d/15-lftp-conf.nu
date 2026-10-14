use bf
use bf-s6
bf env load

# Generate lftp configuration file
def main [] {
    bf write "Generating lftp configuration."
    bf-s6 esh template (bf env FTPS_LFTP_CONF)
}
