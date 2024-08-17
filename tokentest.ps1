# Proxy server configuration
$proxyUrl = "http://your-proxy-server:port" # Replace with your actual proxy URL and port
$proxyUsername = "your-username" # Replace with your actual username
$proxyPassword = "your-password" # Replace with your actual password

# Create a WebProxy object
$proxy = New-Object System.Net.WebProxy($proxyUrl, $true)

# Create NetworkCredentials object for proxy authentication
$proxy.Credentials = New-Object System.Net.NetworkCredential($proxyUsername, $proxyPassword)

# Assign the proxy to the default web request object
[System.Net.WebRequest]::DefaultWebProxy = $proxy

# Test-ApiToken function (same as before)
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
