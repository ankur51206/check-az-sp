Connect-AzureAD
$Applications = Get-AzureADApplication -all $true
$Logs = @()
Write-host "I would like to see the Applications with the Secrets that expire in the next X amount of Days? <<Replace X with the number of days. The answer should be ONLY in Numbers>>" -ForegroundColor Green
$Days = Read-Host

Write-host "Would you like to see Applications with already expired secrets as well? <<Answer with [Yes] [No]>>" -ForegroundColor Green
$AlreadyExpired = Read-Host

$now = get-date

foreach ($app in $Applications) {
    $AppName = $app.DisplayName
    $AppID = $app.objectid
    $ApplID = $app.AppId
    $AppCreds = Get-AzureADApplication -ObjectId $AppID | select PasswordCredentials, KeyCredentials
    $secret = $AppCreds.PasswordCredentials

    foreach ($s in $secret) {
        $StartDate = $s.StartDate
        $EndDate = $s.EndDate
        $operation = $EndDate - $now
        $ODays = $operation.Days

        if ($AlreadyExpired -eq "No") {
            if ($ODays -le $Days -and $ODays -ge 0) {

                $Owner = Get-AzureADApplicationOwner -ObjectId $app.ObjectId
                $Username = $Owner.UserPrincipalName -join ";"
                $OwnerID = $Owner.ObjectID -join ";"
                if ($owner.UserPrincipalName -eq $Null) {
                    $Username = $Owner.DisplayName + " **<This is an Application>**"
                }
                if ($Owner.DisplayName -eq $null) {
                    $Username = "<<No Owner>>"
                }

                $Log = New-Object System.Object

                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationName" -Value $AppName
                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationID" -Value $ApplID
                $Log | Add-Member -MemberType NoteProperty -Name "Secret Start Date" -Value $StartDate
                $Log | Add-Member -MemberType NoteProperty -Name "Secret End Date" -value $EndDate
                $Log | Add-Member -MemberType NoteProperty -Name "Owner" -Value $Username
                $Log | Add-Member -MemberType NoteProperty -Name "Owner_ObjectID" -value $OwnerID

                $Logs += $Log
            }
        }
        elseif ($AlreadyExpired -eq "Yes") {
            if ($ODays -le $Days) {
                $Owner = Get-AzureADApplicationOwner -ObjectId $app.ObjectId
                $Username = $Owner.UserPrincipalName -join ";"
                $OwnerID = $Owner.ObjectID -join ";"
                if ($owner.UserPrincipalName -eq $Null) {
                    $Username = $Owner.DisplayName + " **<This is an Application>**"
                }
                if ($Owner.DisplayName -eq $null) {
                    $Username = "<<No Owner>>"
                }

                $Log = New-Object System.Object
    
                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationName" -Value $AppName
                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationID" -Value $ApplID
                $Log | Add-Member -MemberType NoteProperty -Name "Secret Start Date" -Value $StartDate
                $Log | Add-Member -MemberType NoteProperty -Name "Secret End Date" -value $EndDate
                $Log | Add-Member -MemberType NoteProperty -Name "Owner" -Value $Username
                $Log | Add-Member -MemberType NoteProperty -Name "Owner_ObjectID" -value $OwnerID

                $Logs += $Log
            }
        }
    }

    foreach ($c in $cert) {
        $CStartDate = $c.StartDate
        $CEndDate = $c.EndDate
        $COperation = $CEndDate - $now
        $CODays = $COperation.Days

        if ($AlreadyExpired -eq "No") {
            if ($CODays -le $Days -and $CODays -ge 0) {

                $Owner = Get-AzureADApplicationOwner -ObjectId $app.ObjectId
                $Username = $Owner.UserPrincipalName -join ";"
                $OwnerID = $Owner.ObjectID -join ";"
                if ($owner.UserPrincipalName -eq $Null) {
                    $Username = $Owner.DisplayName + " **<This is an Application>**"
                }
                if ($Owner.DisplayName -eq $null) {
                    $Username = "<<No Owner>>"
                }

                $Log = New-Object System.Object

                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationName" -Value $AppName
                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationID" -Value $ApplID
                $Log | Add-Member -MemberType NoteProperty -Name "Owner" -Value $Username
                $Log | Add-Member -MemberType NoteProperty -Name "Owner_ObjectID" -value $OwnerID

                $Logs += $Log
            }
        }
        elseif ($AlreadyExpired -eq "Yes") {
            if ($CODays -le $Days) {

                $Owner = Get-AzureADApplicationOwner -ObjectId $app.ObjectId
                $Username = $Owner.UserPrincipalName -join ";"
                $OwnerID = $Owner.ObjectID -join ";"
                if ($owner.UserPrincipalName -eq $Null) {
                    $Username = $Owner.DisplayName + " **<This is an Application>**"
                }
                if ($Owner.DisplayName -eq $null) {
                    $Username = "<<No Owner>>"
                }

                $Log = New-Object System.Object

                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationName" -Value $AppName
                $Log | Add-Member -MemberType NoteProperty -Name "ApplicationID" -Value $ApplID
                $Log | Add-Member -MemberType NoteProperty -Name "Owner" -Value $Username
                $Log | Add-Member -MemberType NoteProperty -Name "Owner_ObjectID" -value $OwnerID

                $Logs += $Log
            }
        }
    }
}

Write-host "Add the Path you'd like us to export the CSV file to, in the format of <C:\Users\<USER>\Desktop\Users.csv>" -ForegroundColor Green
$Path = Read-Host
$Logs | Export-CSV $Path -NoTypeInformation -Encoding UTF8
