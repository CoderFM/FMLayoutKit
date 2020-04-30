
# FMCollectionLayout

[![CI Status](https://img.shields.io/travis/周发明/FMCollectionLayout.svg?style=flat)](https://travis-ci.org/周发明/FMCollectionLayout)
[![Version](https://img.shields.io/cocoapods/v/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)
[![License](https://img.shields.io/cocoapods/l/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)
[![Platform](https://img.shields.io/cocoapods/p/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)

## 简介
### 一个可以让你更快的搞定复杂页面的CollectionView自定义布局，目前仅支持纵向布局，可以穿插横向布局，动态cell高度做一些适配可以做到自动计算高度，也可以手动计算通过block返回，代码可以高度集中在一块，效果下面有演示，有什么问题随时issue我，感谢Star


## 安装方式

已发布到CocoaPods. podfile中添加以下代码:

```ruby
pod 'FMCollectionLayout'
```

Spec的官方源实在拉取不下来的话，可以用我自己的一个Spec仓：
```ruby
https://gitee.com/Coder_FM/FMPodSpec.git
```

## 联系方式

周发明, zhoufaming251@163.com

## License

FMCollectionLayout is available under the MIT license. See the LICENSE file for more info.

## 提示

### 使用动态自动计算高度的时候  label的preferredMaxLayoutWidth属性请给一个准确的值  否则计算label布局的高度不准确

## 支持的Cell布局样式以及头部悬停效果
![效果图片](Jietu20200430-151041-HD.gif)

## 多屏滑动效果
![效果图片](Jietu20200430-153346-HD.gif)

具体代码项目里看吧，布局缓存还需要继续优化，api基本不会改动，有使用问题，欢迎联系我随时交流