Param(
  # Name of the scheduled task which will be created
  [Alias()][Parameter(Mandatory=$False)][String]$TaskName = 'WSLInstall'
);

Try
{
  Write-Output "Running WSL2 Install Script: Step 2 - Install Kernel Update & Update Default WSL Version";

  # Download path for the kernel update MSI package
  $OutFile = "$PSScriptRoot\kernel-update.msi";

  # Remote path for the kernel update MSI package
  $OutFileUri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi";

  Write-Output "Downloading wsl kernel update ...";

  Try
  {
    # Download the MSI package
    Invoke-WebRequest -Uri $OutFileUri -OutFile $OutFile;
  }
  Catch
  {
    # Report the download failure to the terminal
    Write-Output "Download failed! Reason: $($_.Exception.Message)";
    Write-Output "Download the file manually, or press enter to exit.";

    Write-Output "File URL: '$OutFileUri'";

    # Set the outfile path to the path of the downloaded file
    $OutFile = Read-Host "Downloaded Path";

    # If the path is blank
    If (-Not $OutFile)
    {
      # Throw the no package provided error
      Throw "No Package Provided!";
    }
  }

  Write-Output "Download complete. Installing update ...";

  # Install the MSI File
  & $OutFile /quiet;

  Write-Output "Install complete. Removing installer ...";

  # Remove the MSI File
  Remove-Item $OutFile;

  Write-Output "Installer deleted. Setting default WSL version to 2 ...";

  # Set WSL Default Version to 2
  wsl --set-default-version 2;

  Write-Output "Default WSL Version assigned. Installation complete.";

  Try
  {
    # If we made it this far, it already exists and we need to remove it
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$False -ErrorAction Stop;
    Write-Output "Scheduled install task deleted.";
  }
  Catch
  {
    Write-Output "Failed to unregister scheduled task! Reason: $($_.Exception.Message)";
    Write-Output "Please delete scheduled task '$TaskName' manually.";
  }
  
  # Prompt the user and open the WSL store if the user hits enter.
  Read-Host "To view distros, click enter. Otherwise, press ctrl-c to exit.";
  
  # Open the WSL Store
  Start-Process "https://aka.ms/wslstore";
}
Catch
{
  Write-Output "Failed to install kernel update! Reason: $($_.Exception.Message)";

  Try
  {
    # Attempt to disable the scheduled task (will not run next logon)
    Disable-ScheduledTask -TaskName $TaskName -Confirm:$False -ErrorAction Stop;

    Write-Output "Scheduled task has been disabled. Please run task '$TaskName' manually.";
  }
  Catch
  {
    # Failed to disable, probably already deleted. Do nothing.
    Write-Output "Failed to unregister scheduled task! Reason: $($_.Exception.Message)";
    Write-Output "Please delete scheduled task '$TaskName' manually.";
  }
}