if ($args.Count -eq 1) {
    $ProcessActive = Get-Process $args[0] -ErrorAction SilentlyContinue



    if ($ProcessActive -ne $null) {
        $exCode = 0
        $msg = $args[0] + " service is running."
    }
    else {
        $exCode = 2
        $msg = $args[0] + " service is stopped!"
    }

    Write-Host "$exCode;$msg"
}
else {
    $exCode = 0
    Write-Host "Syntax error!"
}

exit $exCode