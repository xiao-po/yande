# ![](https://github.com/dart-lang/logos/blob/master/flutter/icon/64.png?raw=true)yande

一个 [yande](http://yande.re) 的第三方 app .可以下载和查看 图片，并且收藏图片和将 tag 加入快捷搜索栏。

## 预览

![](https://raw.githubusercontent.com/xiao-po/readme_image/master/image/yandeIndexPage.jpg)
![](https://raw.githubusercontent.com/xiao-po/readme_image/master/image/yandeRightDrawer.jpg)
![](https://raw.githubusercontent.com/xiao-po/readme_image/master/image/yandeSettingView.jpg)

## 目录结构

```
|-- android
|   |-- app // Android 代码
|-- lib
|   |-- dao // 数据库相关代码
|   |-- model // model 对象
|   |-- route // 路由 
|   |-- service // service 方法
|   |-- utils // 工具类
|   |-- view // view 
|   `-- widget // 公共组件
`-- test
```

## build 
1. 运行 `flutter packages pub run build_runner build ` , 生成 model 的 json factory。如果想直接打包请忽略 1，2 两个步骤。
2. 修改 `lib/model/` 中， `*.g.dart` 中 enum 对象的值. （由于枚举类型不好映射出值，直接修改，也可以通过一个 function 来处理枚举类型的 value， 解决这个问题，我认为修改为 index 的值是最简单的 ）
    
   example:
   
   ```dart
   const _$ImageCollectStatusEnumMap = <ImageCollectStatus, dynamic>{
        ImageCollectStatus.star: 'star',
        ImageCollectStatus.unStar: 'unStar'
      };
   ```
   
   修改为 
   
   ```dart
   const _$ImageCollectStatusEnumMap = <ImageCollectStatus, dynamic>{
     ImageCollectStatus.star: 0,
     ImageCollectStatus.unStar: 1
   };
   ```
3. `flutter build apk`，在 `build/app/outputs/apk/release/` 下找到生成的 apk.

## 第三方依赖

*  [dio](https://pub.dartlang.org/packages/dio)
*  [cached_network_image](https://pub.dartlang.org/packages/cached_network_image)
*  [sqflite](https://pub.dartlang.org/packages/sqflite)
*  [share_extend](https://pub.dartlang.org/packages/share_extend)
*  [photo_view](https://pub.dartlang.org/packages/photo_view)
*  [json_annotation](https://pub.dartlang.org/packages/json_annotation)
*  [path_provider](https://pub.dartlang.org/packages/path_provider)
*  [shared_preferences](https://pub.dartlang.org/packages/shared_preferences)
*  [path](https://pub.dartlang.org/packages/path)


