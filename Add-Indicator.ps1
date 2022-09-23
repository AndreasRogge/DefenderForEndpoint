function Add-Indicator {
    [CmdletBinding()]
    param (   
        [Parameter(Mandatory = $true)]
        [ValidateSet('FileSha1', 'FileSha256', 'IpAddress', 'DomainName', 'Url')]   #validate that the input contains valid value
        [string]$indicatorType,

        [Parameter(Mandatory = $true)]
        [string]$indicatorValue, #an input parameter for the alert's ID	    
    
        [Parameter(Mandatory = $false)]
        [ValidateSet('BlockAndRemediate', 'Block', 'Allowed')]   #validate that the input contains valid value
        [string]$action = 'Alert', #set default action to 'Alert'
    
        [Parameter(Mandatory = $true)]
        [string]$title,     
   
        [Parameter(Mandatory = $false)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High')]   #validate that the input contains valid value
        [string]$severity = 'Informational', #set default severity to 'informational'
    
        [Parameter(Mandatory = $true)]
        [string]$description,

        [Parameter(Mandatory = $false)]
        [string[]]$GroupNames,

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