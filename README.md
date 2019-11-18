


# Shadowsocks for iOS and OSX
===========================

**2019年11月**
### **客户端，我推荐使用 shadowrocket(小火箭)，不单支持ss,ssr也支持vmess 还有其它各种协议！很强大！提供很多学习方向，期间回顾许多网络技术，切换个其它区的appleID，AppSotore搜索shadowrocket，2.99美金！！值**

=======================

今天登陆github，看到好多小伙伴fork我这个库！有点小惊喜。本来这库是备份使用的，为了让小伙伴们感受到shadowsocks的魅力，我把这个项目的使用步骤描述一下！避免大家浪费时间！<br>
这个库，旨在学习网络知识以及方便平时查找学习资料！<br>
旨在学习网络知识以及方便平时查找学习资料！<br>
旨在学习网络知识以及方便平时查找学习资料！<br>

以下是使用的过程:
MAC版是不用怎么配置的，安装了设置了就可以直接使用，以下主要讲手机版：

1.配置shaodowsock服务端（我的是香港服务器）,配置会有密码，加密方式，端口等东西<br>
  当你来找这个的时候，我想你已经配置好了！不知道怎么配，就再用用百度看看先！<br>
2.下载项目,打开终端，cd到项目的目录，pod一下<br>
3.连接手机，启动项目，（如果不成功一般是你证书的问题）<br>
4.点击项目右上角图标，如下图，配置你对应的服务器地址,密码，端口,加密方式，模式等信息<br>
<img width="187.5" height="333.5" src="https://github.com/WuChuming/shadowsocks-iOS/blob/master/IMG_2838.PNG"/><br>
5.设置一下，你wifi的代理，如下图<br>
<img width="187.5" height="333.5" src="https://github.com/WuChuming/shadowsocks-iOS/blob/master/IMG_2839.jpg"/><br>

6.然后，就没有然后了！去试一下吧！！不使用shadowsocks，记得关一下代理!开着代理，有的应用会报没网络<br><br>

有一些注意事项，在APP的帮助里有讲到：<br>
<img width="187.5" height="333.5" src="https://github.com/WuChuming/shadowsocks-iOS/blob/master/IMG_2835.jpg"/><br>
注意：
本项目加入了 应用后台一直运行的功能（背景音乐原理），这样就不用定时去打开项目，如果小伙伴们不需要的话，请删除文件夹runInBg和里面的文件，以及删除appdelegate部分代码即可！

2018年10月20日更新
----
Xcode10后，报错<br>
<img width="500" height="34" src="https://github.com/WuChuming/shadowsocks-iOS/blob/master/xcode10%E6%8A%A5%E9%94%99.png"/><br>
处理的方式：
给项目对应的位置(.../shadowsocks-iOS/OpenSSL-for-iPhone/lib/)添加了静态库 libcrypto.a (项目根目录有lib文件夹，移到OpenSSL-for-iphone文件夹)

iOS
-----
[![iOS Icon](https://raw.github.com/shadowsocks/shadowsocks-iOS/master/ios_128.png)](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Help)  
[iOS Version](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Help)

OSX
-----
[![OSX Icon](https://raw.github.com/shadowsocks/shadowsocks-iOS/master/osx_128.png)](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Shadowsocks-for-OSX-Help)  
[OSX Version](https://github.com/shadowsocks/shadowsocks-iOS/wiki/Shadowsocks-for-OSX-Help)

License
-------
The project is released under the terms of [GPLv3](https://raw.github.com/shadowsocks/shadowsocks-iOS/master/LICENSE).

Bugs and Issues
----------------

Please visit [issue tracker](https://github.com/shadowsocks/shadowsocks-iOS/issues?state=open)

Mailing list: http://groups.google.com/group/shadowsocks

Also see [troubleshooting](https://github.com/clowwindy/shadowsocks/wiki/Troubleshooting)
# shadowsocks-iOS
