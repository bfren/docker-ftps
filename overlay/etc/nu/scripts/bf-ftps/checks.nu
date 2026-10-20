use bf

# Return the reasons the environment cannot be used to start the server - empty if it is valid
export def environment []: nothing -> list<string> {
    let no_address = (bf env --safe FTPS_EXTERNAL_URI) == "" and (bf env --safe FTPS_EXTERNAL_IP) == ""
    [
        [((bf env --safe FTPS_VSFTPD_USER) == "") "BF_FTPS_VSFTPD_USER must be set."]
        [((bf env --safe FTPS_VSFTPD_PASS) == "") "BF_FTPS_VSFTPD_PASS must be set."]
        [$no_address "You must provide either BF_FTPS_EXTERNAL_URI or BF_FTPS_EXTERNAL_IP."]
    ] | where {|x| $x.0 } | each {|x| $x.1 }
}
