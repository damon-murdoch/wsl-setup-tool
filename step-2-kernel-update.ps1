Try
{
  Write-Output "Running WSL2 Install Script: Step 2 - Install Kernel Update & Update Default WSL Version";

  # Download path for the kernel update MSI package
  $OutFile = "$PSScriptRoot\kernel-update.msi";

  Write-Output "Downloading wsl kernel update ...";

  # Download the MSI package
  Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $OutFile;

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
  
  # Prompt the user and open the WSL store if the user hits enter.
  Read-Host "To view distros, click enter. Otherwise, press ctrl-c to exit.";
  
  # Open the WSL Store
  Start-Process "https://aka.ms/wslstore";
}
Catch
{
  Write-Output "Failed to install kernel update! Reason: $($_.Exception.Message)";
}