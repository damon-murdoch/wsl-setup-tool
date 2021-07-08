Param(
  # Option for the install
  # 0: Full Install, 1: Just Step 1, 2: Just Step 2
  [Alias()][Parameter(Mandatory=$False)][Int]$Option
);

Try
{
  Write-Output "Unofficial WSL Setup Tool 1.0"
  Write-Output "Created By Damon Murdoch"
  Write-Output "Github: https://github.com/damon-murdoch/wsl-setup-tool"
  
  # If no option is specified
  If (-Not $Option)
  {
    $Options = @(
      "Full Install",
      "Step 1 (Enable WSL) Only",
      "Step 2 (Kernel Update) Only"
    );
  
    # Allow the user to specify an option
    $Option = Read-Host "0: $($Options[0])`n1: $($Options[1])`n2: $($Options[2])`nSelection";
  
    # If no option is specified
    If (-Not $Option)
    {
      # Set option to default
      $Option = 0;
    }
  
    Write-Output "Option '$Option': '$($Options[$Option])'";
  
    # Switch on the selected option
    Switch($Option)
    {
      0 # Full Install
      { 
        # Run the WSL Install Script
        & "$PSScriptRoot\Scripts\Install-Wsl.ps1";
      }
      1 # Step 1 (Enable WSL) Only
      {
        # Run the WSL Install Script (Skipping Kernel Update)
        & "$PSScriptRoot\Scripts\Install-Wsl.ps1" -SkipKernel;
      }
      2 # Step 2 (Kernel Update) Only
      {
        # Run the Wsl Kernel Update Script 
        & "$PSScriptRoot\Scripts\Install-KernelUpdate.ps1";
      }
      default # Unrecognised Option
      {
        Throw "Not Implemented: '$Option'";
      }
    }
  }
}
Catch
{
  Throw "Install Failed! Reason: $($_.Exception.Message)";
}