# API configuration
$baseApiUrl = "https://api.bluexp.example.com"
$apiToken = "YOUR_API_TOKEN"

# Function to validate the API token
function Test-ApiToken {
    # Create the request URL for a simple API call (e.g., getting account details)
    $testUrl = "$baseApiUrl/accounts"

    try {
        # Make a GET request to the API
        $response = Invoke-RestMethod -Uri $testUrl -Headers @{Authorization = "Bearer $apiToken"} -Method Get

        # Check if the response contains expected data
        if ($response -ne $null -and $response.accounts -ne $null) {
            Write-Host "Token is valid. Successfully connected to BlueXP." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Token is invalid or API response was not as expected." -ForegroundColor Red
            return $false
        }
    } catch {
        # Handle any exceptions (e.g., network issues, authentication failures)
        Write-Host "Failed to connect to BlueXP: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Call the function to test the token
Test-ApiToken
