
# FMCollectionLayout

[![CI Status](https://img.shields.io/travis/周发明/FMCollectionLayout.svg?style=flat)](https://travis-ci.org/周发明/FMCollectionLayout)
[![Version](https://img.shields.io/cocoapods/v/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)
[![License](https://img.shields.io/cocoapods/l/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)
[![Platform](https://img.shields.io/cocoapods/p/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)

## 简介
### 一个可以让你更快的搞定复杂页面（电商首页，方格+列表多样式布局）的CollectionView自定义布局，目前仅支持纵向布局，可以穿插横向布局，动态cell高度做一些适配可以做到自动计算高度，也可以手动计算通过block返回，代码可以高度集中在一块，效果下面有演示，有什么问题随时issue我，感谢Star


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
![效果图片](Jietu20200430-154528@2x.jpg)

#### 分组Cell样式1
单一Cell，固定大小，支持多列，从左往右，从上往下布局
#### 分组Cell样式2
单一Cell，固定大小，支持最大行数，从左往右，如果当前屏幕够放，不会滚动，多的才会滚动

![效果图片](Jietu20200430-154538@2x.jpg)

#### 分组Cell样式3
可以多种Cell，block返回每一个item的大小，从左往右，从上往下，寻找最合适的位置放

![效果图片](Jietu20200430-154718@2x.jpg)
![效果图片](Jietu20200430-154732@2x.jpg)

#### 分组Cell样式4
瀑布流样式，支持多种cell样式，单列就是列表样式，列表可变，高度可以通过手动计算，也可以通过autolayout布局自动计算（续配置数据）

![效果图片](Jietu20200430-154739@2x.jpg)
#### 分组Cell样式5
标签式布局，支持单种cell，可以单行滚动，也可以纵向布局，可限制最大行数（历史搜索记录那种样式）

#### 分组头部支持的样式有4种
- 一般样式跟着滚动
- 悬浮跟着分组滚动
- 一直悬浮，滚动置顶样式
- 第一个分组下拉放大效果（效果无法截图）

## 多屏滑动效果
![效果图片](Jietu20200430-154610@2x.jpg)
![效果图片](Jietu20200430-154705@2x.jpg)

每一个分组都可以设置头部，底部，背景，这三个都有inset可以设置内边距，灵活多变

特斯拉滚动视图是基于FMCollectionLayoutView的，共享的头部是一个FMCollectionLayoutView，横向每一屏都是FMCollectionLayoutView，最底部可以横向滚动是一个ScrollView，当触摸到头部的时候，ScrollView的pan手势会失效，横向滚动时，会将共享的头部移到最顶部视图上，滚动结束静止下来的时候，会将共享头部加到当前上下滚动的FMCollectionLayoutView，以达到效果

具体代码就不贴出来了，项目里看吧，布局缓存还需要继续优化，abi基本不会改动，有使用问题，欢迎联系我随时交流，感谢观看