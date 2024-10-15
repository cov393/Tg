while ($true) {
    if (Test-Connection google.com -Quiet) {
        Write-Host "Conected" -ForegroundColor Green

        $length = Get-Random -Minimum 5 -Maximum 20
        $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        $randomString = -join ((1..$length) | ForEach-Object { $chars[Get-Random -Minimum 0 -Maximum $chars.Length] })
        

        $colors = @("Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White")
        foreach ($char in $randomString.ToCharArray()) {
            $color = $colors[Get-Random -Minimum 0 -Maximum $colors.Length]
            Write-Host $char -NoNewline -ForegroundColor $color
        }
        Write-Host ""  
    } else {
        Write-Host "Disconected" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 5
}
