function intel {
    param(
        [string]$user = "martins3"
    )
    ssh $user@10.0.0.2
}

function n100 {
    param(
        [string]$user = "root"
    )
    ssh $user@10.0.0.5
}
