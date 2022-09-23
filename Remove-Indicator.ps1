function Remove-Indicator {
    [CmdletBinding()]
    param (   
        [Parameter(Mandatory = $true)]
        [int]$indicatorId
    )
    
    begin {
        $url = "https://api-eu.securitycenter.microsoft.com/api/indicators/" + $indicatorId
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