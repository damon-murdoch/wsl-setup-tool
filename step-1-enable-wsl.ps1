Try
{
  Write-Output "Running WSL2 Install Script: Step 1 - Enable WSL & VM Platform";

  # Get the window security principal
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

  Write-Output "";

  # If this session is running as an administrator
  If ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
  {
    Write-Output "Enabling WSL Feature ...";

    # Enable Windows Subsystem for Linux
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart;

    Write-Output "WSL Enabled. Checking current OS Version ...";

    # Get the current windows version
    $OSVersion = [System.Environment]::OSVersion.Version;

    # If the OS Build is greater than 18362
    If ($OSVersion.Build -gt 18362)
    {
      Write-Output "OS Version passed. Enabling Virtual Machine Platform ...";

      # Enable the virtual machine feature
      dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all;

      Write-Output "Virtual Machine Platform enabled.";
    }
    Else
    {
      Write-Output "Install cancelled! Required OS Version: 18362, Current Version: $($OSVersion.Build)";
    }
  }
  Else # Session is not running as an administrator
  {
    Write-Output "Session is not running as an administrator. Please re-execute with administrator privileges.";
  }
}
Catch
{
  Write-Output "Step Failed! Reason: $($_.Exception.Message)";
}