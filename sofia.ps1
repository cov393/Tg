Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# API configuration
$baseApiUrl = "https://api.bluexp.example.com"
$apiToken = "YOUR_API_TOKEN"

# Function to retrieve the list of users
function Get-Users {
    $usersUrl = "$baseApiUrl/accounts/{accountId}/users"
    $response = Invoke-RestMethod -Uri $usersUrl -Headers @{Authorization = "Bearer $apiToken"} -Method Get
    return $response.users
}

# Function to add a new user
function Add-UserFunction {
    $newUserEmail = $txtEmail.Text
    # Determine the role based on the selected radio button
    $role = if ($rbAccountAdmin.Checked) { "AccountAdmin" } else { "WorkspaceAdmin" }

    # Create the user object
    $newUser = @{
        email = $newUserEmail
        role = $role
    }

    # API endpoint to add the user
    $addUserUrl = "$baseApiUrl/accounts/{accountId}/users"
    # Send the POST request to add the user
    $response = Invoke-RestMethod -Uri $addUserUrl -Headers @{Authorization = "Bearer $apiToken"} -Method Post -Body ($newUser | ConvertTo-Json)

    # Check the response and show a message box with the result
    if ($response.status -eq "Success") {
        [System.Windows.Forms.MessageBox]::Show("User added successfully!", "Success")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Error occurred: $($response.error)", "Error")
    }
}

# Function to remove an existing user
function Remove-UserFunction {
    $userEmail = $txtEmail.Text

    # API endpoint to remove the user
    $removeUserUrl = "$baseApiUrl/accounts/{accountId}/users/$userEmail"
    # Send the DELETE request to remove the user
    $response = Invoke-RestMethod -Uri $removeUserUrl -Headers @{Authorization = "Bearer $apiToken"} -Method Delete

    # Check the response and show a message box with the result
    if ($response.status -eq "Success") {
        [System.Windows.Forms.MessageBox]::Show("User removed successfully!", "Success")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Error occurred: $($response.error)", "Error")
    }
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "S.O.F.I.A. - BlueXP User Management"
$form.Size = New-Object System.Drawing.Size(400, 300)

# Label for the Email field
$lblEmail = New-Object System.Windows.Forms.Label
$lblEmail.Text = "User Email:"
$lblEmail.Location = New-Object System.Drawing.Point(10, 20)
$lblEmail.Size = New-Object System.Drawing.Size(120, 23)
$form.Controls.Add($lblEmail)

# TextBox for entering the Email
$txtEmail = New-Object System.Windows.Forms.TextBox
$txtEmail.Location = New-Object System.Drawing.Point(140, 20)
$txtEmail.Size = New-Object System.Drawing.Size(200, 23)
$form.Controls.Add($txtEmail)

# RadioButton for selecting Account Admin role
$rbAccountAdmin = New-Object System.Windows.Forms.RadioButton
$rbAccountAdmin.Text = "Account Admin"
$rbAccountAdmin.Location = New-Object System.Drawing.Point(140, 60)
$rbAccountAdmin.Checked = $true
$form.Controls.Add($rbAccountAdmin)

# RadioButton for selecting Workspace Admin role
$rbWorkspaceAdmin = New-Object System.Windows.Forms.RadioButton
$rbWorkspaceAdmin.Text = "Workspace Admin"
$rbWorkspaceAdmin.Location = New-Object System.Drawing.Point(140, 90)
$form.Controls.Add($rbWorkspaceAdmin)

# Button to add a new user
$btnAddUser = New-Object System.Windows.Forms.Button
$btnAddUser.Location = New-Object System.Drawing.Point(10, 130)
$btnAddUser.Size = New-Object System.Drawing.Size(100, 23)
$btnAddUser.Text = "Add User"
$form.Controls.Add($btnAddUser)

# Button to remove an existing user
$btnRemoveUser = New-Object System.Windows.Forms.Button
$btnRemoveUser.Location = New-Object System.Drawing.Point(120, 130)
$btnRemoveUser.Size = New-Object System.Drawing.Size(100, 23)
$btnRemoveUser.Text = "Remove User"
$form.Controls.Add($btnRemoveUser)

# Event handler for the Add User button click
$btnAddUser.Add_Click({
    Add-UserFunction
})

# Event handler for the Remove User button click
$btnRemoveUser.Add_Click({
    Remove-UserFunction
})

# Run the form
$form.ShowDialog()
