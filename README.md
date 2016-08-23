我的天气
======
我的天气是一个简明而精致的天气app。
#Screen Shot
![](https://github.com/leonardlee2015/MyWeather/blob/master/snapshot/start2.gif)<br>
![](https://github.com/leonardlee2015/MyWeather/blob/master/snapshot/CityManager.gif)<br>
![](https://github.com/leonardlee2015/MyWeather/blob/master/snapshot/forecast2.gif)
#Installation
```bash
cd MyWheaher
rm -rf Pofile.lock
pod install --no-verbose --no-repo-update
```
#Dependency
- [FMDB](https://github.com/ccgus/fmdb)
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [Pop](https://github.com/facebook/pop)
- [string-to-CGPathRef](https://github.com/aderussell/string-to-CGPathRef)
- [TWMessageBarManager](https://github.com/terryworona/TWMessageBarManager)

#Platform
iMac 5K:

- OS X 10.10.4 (14E46)

Xcode:

- Version 7.3
- SDK: iOS SDK 
- Deployment Taget: 8.0 ~ 9.3


#Version
 _ V2.0.1 添加多城市天气支持，更换天气数据源，添加天气界面进入多城市管理界面和天气更新功能。
 - V1.0.0 删除之前的实例，重新上传版本
