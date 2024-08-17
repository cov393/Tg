# API configuration
$baseApiUrl = "https://api.bluexp.example.com"
$apiToken = "YOUR_API_TOKEN"

# Proxy server configuration (assuming it uses Windows Integrated Authentication)
$proxyUrl = "http://your-proxy-server:port" # Replace with your actual proxy URL and port

# Create a WebProxy object
$proxy = New-Object System.Net.WebProxy($proxyUrl, $true)

# Set credentials to the current user's default credentials (Windows Integrated Authentication)
$proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

# Assign the proxy to the default web request object
[System.Net.WebRequest]::DefaultWebProxy = $proxy

# Function to validate the API token
function Test-ApiToken {
    $testUrl = "$baseApiUrl/accounts"

    try {
        # Make a GET request to the API
        $response = Invoke-RestMethod -Uri $testUrl -Headers @{Authorization = "Bearer $apiToken"} -Method Get

        if ($response -ne $null -and $response.accounts -ne $null) {
            Write-Host "Token is valid. Successfully connected to BlueXP." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Token is invalid or API response was not as expected." -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "Failed to connect to BlueXP: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Call the function to test the token
Test-ApiToken
