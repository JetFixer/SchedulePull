# git repository one-click update tool
SchedulePull.ps1: Main script.  
start.bat: (Optional) Start script, double-click to start main script.  
repo.ini: Configure the repository, remote, and branches that need to be updated.  
history.log: Command execution log, overwritten after each execution.  

repo.ini:  
Repository, remote and branches in each line. Separated by spaces.  
Will use remote and branches in the previous row if not specified.  
Example:  

    D:\Code\GoProject origin master
    D:\Code\CppProject team master slave
    D:\Code\CppAnother                  # CppAnother will pull master & slave from team


Use WINDOWS tasks schedule to update automatically and periodically：

    1.Execute taskschd.msc with terminal or cmd, or open the task schedule window manually;
    2.Create a task. Create a new plan in the Trigger with the period you need;
    3.In the Operation:
        Program or Script: powershell
        Parameter: -File [Absolute path of SchedulePull.ps1]
        Start: [Directory of this project]
    4.Complete and debug.