function Get-Indicator {
    [CmdletBinding()]
    param (
        # Get All indicators. Attention Web Content Filtering is also inside the results
        [Parameter(Mandatory = $false)]
        [switch]
        $All,

        #indicator value like 1.1.1.1 or https://google.com
        [Parameter(Mandatory = $false)]
        [string[]]$indicatorValue,

        #get indicator with the following type
        [Parameter(Mandatory = $false)]
        [ValidateSet('FileSha1', 'FileMd5', 'FileSha256', 'IpAddress', 'DomainName', 'Url', 'CertificateThumbprint')]  
        [string[]]$indicatorType,

        #which Device Group should be get indicator
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