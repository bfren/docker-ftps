use bf

# Run preflight checks before executing process
export def preflight [] {
    # load environment
    bf env load

    # manually set executing script
    bf env x_set --override run vsftpd

    # if we get here we are ready to start vsftpd
    bf write "Starting vsftpd."
}
