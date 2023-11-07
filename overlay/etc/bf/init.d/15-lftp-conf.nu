use bf
bf env load

# Generate lftp configuration file
def main [] {
    bf write "Generating lftp configuration."
    bf esh template (bf env FTPS_LFTP_CONF)
}
