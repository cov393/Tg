# Инициализация Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Создание формы
$form = New-Object Windows.Forms.Form
$form.Text = "Avoid the Falling Blocks"
$form.Size = New-Object Drawing.Size(400, 600)
$form.StartPosition = "CenterScreen"

# Создание персонажа
$player = New-Object Windows.Forms.PictureBox
$player.Size = New-Object Drawing.Size(50, 50)
$player.BackColor = [System.Drawing.Color]::Blue
$player.Location = [System.Drawing.Point]::new(175, 500)
$form.Controls.Add($player)

# Создание счетчика разрушенных объектов
$scoreLabel = New-Object Windows.Forms.Label
$scoreLabel.Text = "Score: 0"
$scoreLabel.Location = [System.Drawing.Point]::new(10, 10)
$form.Controls.Add($scoreLabel)

# Создание падающих объектов
$fallingObjects = @()
for ($i = 0; $i -lt 5; $i++) {
    $fallingObject = New-Object Windows.Forms.PictureBox
    $fallingObject.Size = New-Object Drawing.Size(50, 50)
    $fallingObject.BackColor = [System.Drawing.Color]::Red
    $fallingObject.Location = [System.Drawing.Point]::new((Get-Random -Minimum 0 -Maximum 350), (Get-Random -Minimum -600 -Maximum 0))
    $fallingObject.Tag = 0 # Количество попаданий
    $form.Controls.Add($fallingObject)
    $fallingObjects += $fallingObject
}

# Создание выстрелов
$bullets = @()

# Счетчик разрушенных объектов
$destroyedCount = 0

# Управление персонажем и выстрелами с помощью клавиш
$form.Add_KeyDown({
    param($sender, $e)
    switch ($e.KeyCode) {
        'Left' {
            if ($player.Location.X - 10 -ge 0) {
                $player.Location = [System.Drawing.Point]::new($player.Location.X - 10, $player.Location.Y)
            }
        }
        'Right' {
            if ($player.Location.X + 10 -le 350) {
                $player.Location = [System.Drawing.Point]::new($player.Location.X + 10, $player.Location.Y)
            }
        }
        'Space' {
            $bullet = New-Object Windows.Forms.PictureBox
            $bullet.Size = New-Object Drawing.Size(5, 10)
            $bullet.BackColor = [System.Drawing.Color]::Yellow
            $bullet.Location = [System.Drawing.Point]::new($player.Location.X + 22, $player.Location.Y - 10)
            $form.Controls.Add($bullet)
            $bullets += $bullet
            Write-Host "Bullet created at: $($bullet.Location.X), $($bullet.Location.Y)"
        }
    }
})

# Обновление позиции падающих объектов и выстрелов
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 50
$timer.Add_Tick({
    # Обновление падающих объектов
    foreach ($obj in $fallingObjects) {
        $obj.Location = [System.Drawing.Point]::new($obj.Location.X, $obj.Location.Y + 10)
        if ($obj.Location.Y -ge 600) {
            $obj.Location = [System.Drawing.Point]::new((Get-Random -Minimum 0 -Maximum 350), (Get-Random -Minimum -600 -Maximum 0))
            $obj.Tag = 0 # Сброс количества попаданий
        }
        if ($obj.Bounds.IntersectsWith($player.Bounds)) {
            $timer.Stop()
            [System.Windows.Forms.MessageBox]::Show("Game Over!")
            $form.Close()
        }
    }

    # Обновление выстрелов
    foreach ($bullet in @($bullets)) {
        $bullet.Location = [System.Drawing.Point]::new($bullet.Location.X, $bullet.Location.Y - 10)

        # Отладочные сообщения
        Write-Host "Bullet Position: $($bullet.Location.X), $($bullet.Location.Y)"

        if ($bullet.Location.Y -le 0) {
            $form.Controls.Remove($bullet)
            $bullets = $bullets | Where-Object { $_ -ne $bullet }
            Write-Host "Bullet removed at: $($bullet.Location.X), $($bullet.Location.Y)"
        } else {
            foreach ($obj in $fallingObjects) {
                if ($bullet.Bounds.IntersectsWith($obj.Bounds)) {
                    $form.Controls.Remove($bullet)
                    $bullets = $bullets | Where-Object { $_ -ne $bullet }
                    $obj.Tag++
                    if ($obj.Tag -ge 5) {
                        $form.Controls.Remove($obj)
                        $fallingObjects = $fallingObjects | Where-Object { $_ -ne $obj }
                        $destroyedCount++
                        $scoreLabel.Text = "Score: $destroyedCount"
                        $newObject = New-Object Windows.Forms.PictureBox
                        $newObject.Size = New-Object Drawing.Size(50, 50)
                        $newObject.BackColor = [System.Drawing.Color]::Red
                        $newObject.Location = [System.Drawing.Point]::new((Get-Random -Minimum 0 -Maximum 350), (Get-Random -Minimum -600 -Maximum 0))
                        $newObject.Tag = 0
                        $form.Controls.Add($newObject)
                        $fallingObjects += $newObject
                    }
                    break
                }
            }
        }
    }
})

# Запуск таймера и отображение формы
$timer.Start()
[void]$form.ShowDialog()
