function Get-Indicator {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $false)]
        [switch]
        $All,

        #an input parameter for the alert's ID
        [Parameter(Mandatory = $false)]
        [string[]]$indicatorValue,

        #validate that the input contains valid value
        [Parameter(Mandatory = $false)]
        [ValidateSet('FileSha1', 'FileMd5', 'FileSha256', 'IpAddress', 'DomainName', 'Url', 'CertificateThumbprint')]  
        [string[]]$indicatorType,

        [Parameter(Mandatory = $false)]
        [string[]]$GroupNames
    )
    
    begin {
        $url = "https://api-eu.securitycenter.microsoft.com/api/indicators"
    }
    
    process {
        $authHeaders = Get-Token
        if ($authHeaders) {
            if ($All) {
            $response = Invoke-WebRequest -Method Get -Uri $url -Headers $authHeaders -ErrorAction Stop
            } elseif ($indicatorValue) {
                $url = $url + "?`$filter=indicatorValue+eq+`'$($indicatorValue)`'"
                $response = Invoke-WebRequest -Method Get -Uri $url -Headers $authHeaders -ErrorAction Stop
            } elseif ($indicatorType) {
                
            }
            if ($response.StatusCode -eq 200) {
                #chcek the response status code
                $JSONresponse = ($response.Content | ConvertFrom-Json).Value
                return $JSONresponse        #update ended successfully
            } else {
                return $null       #update failed
            }
        } else {
            Write-Host "Problem receiving token"
        }
    }
    
    end {
        
    }
}