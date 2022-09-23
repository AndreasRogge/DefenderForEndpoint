function Get-Token {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $AppId = "[AppId]]"
        $TenantId = "[TenantId]"
        $ClientSecret = "[ClientSecret]"
        $oAuthUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
        $resourceAppIdUri = "https://api-eu.securitycenter.microsoft.com/"

        $authBody = [Ordered] @{
            resource      = $resourceAppIdUri
            client_id     = $AppId
            client_secret = $ClientSecret
            grant_type    = 'client_credentials'
        }
    }
    
    process {
        $authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
        $token = $($authResponse.access_token)

        $authHeaders = @{ 
            'Content-Type' = 'application/json'
            Accept         = 'application/json'
            Authorization  = "Bearer $token"
        }

        if ($authHeaders) {
            return $authHeaders
        } else {
            return $null
        }
    }
    
    end {
        
    }
}