fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

| Method                     | OS support                              | Description                                                                                                                           |
|----------------------------|-----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| [Homebrew](http://brew.sh) | macOS                                   | `brew cask install fastlane`                                                                                                          |
| Installer Script           | macOS                                   | [Download the zip file](https://download.fastlane.tools). Then double click on the `install` script (or run it in a terminal window). |
| RubyGems                   | macOS or Linux with Ruby 2.0.0 or above | `sudo gem install fastlane -NV`                                                                                                       |

# Available Actions
### ManagerLibs
```
fastlane ManagerLibs
```
使用ManagerLibs脚本，可以对自己的私有库进行快速的升级维护。

使用脚本命令组成（ManagerLibs为我的脚本名称），接收四个参数: fastlane ManagerLibs tag:[版本号] message:"[本次升级的日志]" repo:[私有库名称] podspec:[podspec名称]

案例：fastlane ManagerLibs tag:[1.0.0] message:"封装私有库" repo:BruceLiLibs  podspec: fastlaneDemo

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
