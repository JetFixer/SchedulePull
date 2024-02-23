# git仓库一键更新工具
SchedulePull.ps1: 主程序。  
start.bat: (可选)启动脚本，用以双击执行主程序。  
repo.ini: 配置需更新的仓库、远程、分支。  
history.log: 命令执行结果记录，每次执行后将覆盖。

repo.ini格式:  
每一行填写一个本地仓库地址，以及远程名称、需要更新的分支名。以空格分隔。  
若仅填写的本地仓库，则远程、分支采用上一个填写了远程、分支的仓库的配置。  
示例:  

    D:\Code\GoProject origin master
    D:\Code\CppProject team master slave
    D:\Code\CppAnother                  #CppAnother将从远程team更新拉取master、slave分支


配合windows任务计划，可实现定时自动更新。使用方法如下：

    1.windows终端或运行串口执行taskschd.msc，或手动打开任务计划窗口；
    2.创建任务。根据所需的更新周期在“触发器”中新建计划；
    3.在“操作”中填写如下：
        “程序或脚本”: powershell
        “参数”: -File [主程序绝对路径]
        “起始”: [主程序所在目录]
    4.完成并调试。