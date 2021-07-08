# wsl-setup-tool
## Powershell scripts for installing WSL
### Created by Damon Murdoch 

## Description
This is an application developed for automating the windows subsystem for linux (WSL) install process. The application can now perform the entire process with a single execution, assuming that all installs are successful. Verbose debugging information is provided in the case of an error during the installation.

### Installation
1. Run the Install-Wsl.ps1 powershell file
```
./Install-Wsl.ps1
```
2. Unless you are doing a custom install, press enter when prompted or enter the option '0'.
```
Unofficial WSL Setup Tool 1.0
Created By Damon Murdoch
Github: https://github.com/damon-murdoch/wsl-setup-tool
0: Full Install
1: Step 1 (Enable WSL) Only
2: Step 2 (Kernel Update) Only
Selection: 0
0: Full Install
```
3. Allow the install to complete, and you will be prompted to perform a reboot. If you would press enter to reboot automatically or cancel and restart manually.
4. Upon restarting, the following step of the installation will proceed. Allow these steps to occur, and ensure they pass without issue.  
5. Installation is completed! If the logs report the scheduled tasks failed to delete, please disable or delete them using the task scheduler.

## Future Changes
A list of future planned changes are listed below.

| Change Description | Priority |
| ------------------ | -------- | 
| No planned changes | -        |

### Problems or improvements
If you have any suggested fixes or improvements for this project, please 
feel free to open an issue [here](../../issues).

