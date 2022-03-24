Function Get-JPSRunAsUserToken { 
<#
.SYNOPSIS
Opens process for a user and gets token

.DESCRIPTION
Retrieves a duplicate token based on the user we are searching for.

.PARAMETER username
Name of the user account you are trying to access.

.EXAMPLE
PS> 
$token = Get-JPSRunAsToken 
[System.Security.Principal.WindowsIdentity]::GetCurrent().name
[System.Security.Principal.WindowsIdentity]::Impersonate($token)
[System.Security.Principal.WindowsIdentity]::GetCurrent().name
[System.Security.Principal.WindowsIdentity]::Impersonate(0)
[System.Security.Principal.WindowsIdentity]::GetCurrent().name

.LINK
http://www.JPScripter.com/extension.html

#>
    param(  
        $Username = 'NT AUTHORITY\SYSTEM'
    )
    Begin{
        #Check for admin
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent())
        if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true) {
          Throw "Run the Command as an Administrator"
        }
    }
    Process {
   
        $SecurityAttibutes.nLength = [System.Runtime.InteropServices.Marshal]::SizeOf($SecurityAttibutes)
        $status = [Pinvoke.advapi32]::DuplicateTokenEx($ProcessToken, [System.Security.Principal.TokenAccessLevels]::MaximumAllowed, [ref] $SecurityAttibutes, [pinvoke.SECURITY_IMPERSONATION_LEVEL]::SecurityImpersonation, [pinvoke.TOKEN_TYPE]::TokenImpersonation, [ref] $ImpersonationToken)

        if ($status){
            Write-Verbose -Message "Found Token for system"
            $ImpersonationToken 
        }else{
            Throw "Failed to duplicate token"
        }
    }
    End {

    }
}