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

# Return the reason the certificate cannot be used yet - empty if it is ready
#
# A certificate provided by another container (e.g. bfren/caddy-proxy) may be an empty placeholder until it has been
# obtained, or a directory if Docker created it because the bind-mounted file did not exist
export def cert [
    file: string    # Path to the certificate file
]: nothing -> string {
    match ($file | path type) {
        "file" => { if (ls $file | first | get size) == 0b { $"($file) is empty - waiting for the certificate" } else { "" } }
        "dir" => $"($file) is a directory - Docker creates one if a mounted file does not exist, so create the file and remove the directory"
        _ => $"($file) does not exist"
    }
}
