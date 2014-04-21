function PolicyCatolog-Upload($url,$feed,$domain,$category){
    # Requires pshell 3.0
    # Function to uplad found URLs to bluecoat Catalog
    # Example PolicyCatalog-Upload -url evil.com -feed "where I got this evil site" -domain "myCompany'sDomainName" -category "Evil"

    if ($cred -eq $null)
    {
        $cred = get-credential
        $username = $cred.GetNetworkCredential().UserName
        $password = $cred.GetNetworkCredential().Password
    }
    
    [xml]$pcat = Invoke-RestMethod -Uri "http://policycatalog.$domain.com/categories/$category/entries" -Method get -ContentType "text/xml"

    $URls = $pcat.entries.entry | select -ExpandProperty url

    foreach ($pcaturl in $URls)
    {
        #write-host $pcaturl
        
        if ($pcaturl -notcontains "$url")
        {
           $a = 1
        }
        else
        {
            $switch = "1"
        }       
    }
    
    if ($switch -eq $null)
    {

        $EncodedAuthorization = [System.Text.Encoding]::UTF8.GetBytes($username + ':' + $password)
        $EncodedPassword = [System.Convert]::ToBase64String($EncodedAuthorization)
   
        $headers = @{"Authorization"="Basic $($EncodedPassword)"}

        $body = "<entry><url>$url</url><comment>$feed</comment><approved>yes</approved></entry>"

        Invoke-RestMethod -uri "http://policycatalog.$domain.com/categories/$catagory/entries" `
         -Headers $headers `
         -body $body `
         -Method Post `
         -ContentType "text/xml"       
    }
}
