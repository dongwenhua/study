adb devices -l
adb shell wm size


adb 查看mac地址
adb shell ip address show wlan0 | grep "link/ether" | awk '{printf $2}'
