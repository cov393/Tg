while ($true) {
    if (Test-Connection google.com -Quiet) {
        Write-Host "Conected" -ForegroundColor Green

        # Генерация случайной строки из цифр и букв
        $length = Get-Random -Minimum 50 -Maximum 200
        $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789qazxswedcvfrtgbnhyujmkiolp.@~'.ToCharArray()
        
        # Создаем случайную строку
        $randomString = ""
        for ($i = 0; $i -lt $length; $i++) {
            # Генерация случайного индекса для выбора символа
            $randomIndex = Get-Random -Minimum 0 -Maximum $chars.Count
            $randomChar = $chars[$randomIndex]
            $randomString += $randomChar
        }
        
        # Генерация случайных цветов для каждого символа
        $colors = @("Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White")
        foreach ($char in $randomString.ToCharArray()) {
            # Генерация случайного индекса для выбора цвета
            $colorIndex = Get-Random -Minimum 0 -Maximum $colors.Count
            $color = $colors[$colorIndex]
            Write-Host $char -NoNewline -ForegroundColor $color
        }
        Write-Host ""  # Перевод на новую строку
    } else {
        Write-Host "Disconected" -ForegroundColor Red
    }

    Start-Sleep -Seconds 5
}
