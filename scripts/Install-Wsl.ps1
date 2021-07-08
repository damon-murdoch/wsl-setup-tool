Param(
  # Name of the scheduled task which will be created
  [Alias()][Parameter(Mandatory=$False)][String]$TaskName = 'WSLInstall', 

  # Boolean, if this is set to true the scheduled task for part 2 will not be created
  [Alias()][Parameter(Mandatory=$False)][Switch]$SkipKernel = $False
);

Try
{
  Write-Output "Running WSL2 Install Script: Step 1 - Enable WSL & VM Platform";

  # Get the window security principal
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

  Write-Output "Verifying user is administrator ...";

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
      Throw "Install cancelled! Required OS Version: 18362, Current Version: $($OSVersion.Build)";
    }

    # If the kernel update is required
    If (-Not $SkipKernel)
    {
      # Attempt to create the kernel update scheduled task
      Try
      {
        Write-Output "Following steps pending reboot. Creating scheduled task ...";

        # Setup a scheduled task (after reboot) for running the kernel update
        $Action = New-ScheduledTaskAction -Execute "scheduled-task.bat" -WorkingDirectory "$PSScriptRoot\";

        # Create the scheduled task triggr
        $Trigger = New-ScheduledTaskTrigger -AtLogOn;

        Try
        {
          # Attempt to remove the scheduled task (if it exists)
          Unregister-ScheduledTask -TaskName $TaskName -Confirm:$False -ErrorAction Stop;

          Write-Output "Previous version of task '$TaskName' removed.";
        }
        Catch
        {
          # Does not exist, no action required
        }

        # Register the scheduled task
        Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Description "WSL Install Kernel Update Task" | Out-Null;

        Write-Output "Scheduled task '$TaskName' created. Installation will proceed after a reboot.";
      }
      Catch
      {
        Throw "Failed to create scheduled task! Reason: $($_.Exception.Message)";
      }
    }
    Else # Kernel update is not required
    {
      Write-Output "Kernel update has been skipped. No scheduled task has been created.";
    }

    Read-Host "If you would like to reboot now, press enter. Otherwise, press ctrl-c to exit the installer.";

    # Restart the computer
    Restart-Computer;
  }
  Else # Session is not running as an administrator
  {
    Throw "Session is not running as an administrator. Please re-execute with administrator privileges.";
  }
}
Catch
{
  Write-Output "Step Failed! Reason: $($_.Exception.Message)";
}