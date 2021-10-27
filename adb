adb devices -l
adb shell wm size


adb 查看mac地址
adb shell ip address show wlan0 | grep "link/ether" | awk '{printf $2}'


获取本地已安装应用APK

adb shell pm list packages

adb shell pm path com.sticktoit

adb pull /data/app/com.sticktoit-BbbbPJuoMAbxXRudFBg6gw==/base.apk D:\work



无机器人的副本
gm test-start-matchmaking test 100011 1 false test



殷天翔 5-15 18:45:44
我刚刚提交了  自己用GM命令生成NPC     ID是 30004


董文华 5-8 17:00:14
刷NPC的命令再发一遍呗

陈靖 5-8 17:01:14
dm createnpc id x y    id是npc的id x, y 是相对自己的偏移 厘米



adb devices -l
adb install U
获取序列号：

adb get-serialno

获取机器MAC地址：

adb shell cat /sys/class/net/wlan0/address

adb shell ip address show wlan0 | grep "link/ether" | awk '{printf $2}'

adb shell pm path com.tencent.tmgp.wuxia
adb pull /data/app/com.tencent.tmgp.wuxia-C9GEN2jBNZ_s-So-DnZpVA==/base.apk D:\Videos\Captures

唤醒屏幕
SERIAL=81CEBLX224V6 
adb -s $SERIAL shell input keyevent 26

查看指定设备的信息
adb -s 236413b9 shell cat /system/build.prop | grep product
