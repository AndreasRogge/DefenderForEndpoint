function Add-Indicator {
    [CmdletBinding()]
    param (
        #add indicator with the following type
        [Parameter(Mandatory = $true)]
        [ValidateSet('FileSha1', 'FileMd5', 'FileSha256', 'IpAddress', 'DomainName', 'Url', 'CertificateThumbprint')]   
        [string]$indicatorType,

        #indicator value like 1.1.1.1 or https://google.com
        [Parameter(Mandatory = $true)]
        [string]$indicatorValue,    
    
        #should the indicator be blocked or allowed
        [Parameter(Mandatory = $false)]
        [ValidateSet('BlockAndRemediate', 'Block', 'Allowed')]
        [string]$action = 'Alert',
    
        #title to identitfy the indicator
        [Parameter(Mandatory = $true)]
        [string]$title,     
   
        #severity when user opens indicator
        [Parameter(Mandatory = $false)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High')]
        [string]$severity = 'Informational',
    
        #description of indicator
        [Parameter(Mandatory = $true)]
        [string]$description,

        #which Device Group should be added to this indicator
        [Parameter(Mandatory = $false)]
        [string[]]$GroupNames,

        #description of the action that should be done
        [Parameter(Mandatory = $false)]
        [string]$recommendedActions     
    )
    
    begin {
        $url = "https://api-eu.securitycenter.microsoft.com/api/indicators"
    }
    
    process {
        $authHeaders = Get-Token
        if ($authHeaders) {
            $body = @{
                indicatorValue     = $indicatorValue        
                indicatorType      = $indicatorType 
                action             = $action
                title              = $title 
                severity           = $severity	
                description        = $description 
                recommendedActions = $recommendedActions
                rbacGroupNames     = @($GroupNames)
            }
 
            $response = Invoke-WebRequest -Method Post -Uri $url -Body ($body | ConvertTo-Json) -Headers $authHeaders -ErrorAction Stop

            if ($response.StatusCode -eq 200) {
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