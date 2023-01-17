function Remove-Device {
    [CmdletBinding()]
    param (
        #id from indicator which can be obtained with Get-Indicator
        [Parameter(Mandatory = $true)]
        [int]$deviceId
    )
    
    begin {
        $url = "https://api.securitycenter.microsoft.com/api/machines/$($deviceId)/offboard"
        
    }
    
    process {
        $authHeaders = Get-Token
        if ($authHeaders) {
            $response = Invoke-WebRequest -Method Delete -Uri $url -Headers $authHeaders -ErrorAction Stop

            if ($response.StatusCode -eq 204) {
                #chcek the response status code
                return $true        #update ended successfully
            } else {
                return $false       #update failed
            }
        } else {
            Write-Host "Problem receiving token"
        }
    }
    
    end {
        
    }
}