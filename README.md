
# FMLayoutKit

[![CI Status](https://img.shields.io/travis/周发明/FMLayoutKit.svg?style=flat)](https://travis-ci.org/周发明/FMLayoutKit)
[![Version](https://img.shields.io/cocoapods/v/FMLayoutKit.svg?style=flat)](https://cocoapods.org/pods/FMLayoutKit)
[![License](https://img.shields.io/cocoapods/l/FMLayoutKit.svg?style=flat)](https://cocoapods.org/pods/FMLayoutKit)
[![Platform](https://img.shields.io/cocoapods/p/FMCollectionLayout.svg?style=flat)](https://cocoapods.org/pods/FMCollectionLayout)

## 简介
### 一个可以让你更快的搞定复杂页面（电商首页，方格+列表多样式布局）的CollectionView自定义布局，目前仅支持纵向布局，可以穿插横向布局，动态cell高度做一些适配可以做到自动计算高度，也可以手动计算通过block返回，代码可以高度集中在一块，效果下面有演示，有什么问题随时issue我，感谢Star


## 安装方式

已发布到CocoaPods. podfile中添加以下代码:

```ruby
pod 'FMLayoutKit'
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

### 使用示例
``` objc
/// 创建CollectionView  delegate以及dataSource默认自己已遵守实现了一些方法
FMCollectionLayoutView *view = [[FMCollectionLayoutView alloc] init];
/// 需要布局的分组
[view.layout setSections:self.shareSections];
view.backgroundColor = [UIColor whiteColor];
[self.view addSubview:view];
[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(0);
    make.top.mas_equalTo(100);
}];
self.collectionView = view;

/// 固定大小 单一cell样式的分组
 FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];
/// 配置分组头部  高度以及view类
section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
/// 头部最底距离item的间距
section.header.bottomMargin = 10;
/// 头部样式是否悬停
section.header.type = FMSupplementaryTypeSuspensionBigger;
/// 头部内边距
section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
/// 
[section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
    FMCollectionCustomDecoration *customHeader = (FMCollectionCustomDecoration *)header;
    customHeader.textLabel.text = @"固定大小, 从左往右从上往下排的分组, 头部放大缩放效果";
}];
/// 配置分组底部
section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
section.footer.topMargin = 10;

/// 配置Item样式
/// 是否可以横向滚动
section.isHorizontalCanScroll = YES;
section.itemSize = CGSizeMake(100, 100);
section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
/// cell的类 可以纯代码也可以Xib
section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
/// cell赋值数据
[section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
    
}];
/// cell点击事件
[section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
    FMAddViewController *add = [[FMAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}];

#pragma mark --- 动态分组
/// cell类的数组
section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
/// 需固定宽度
section.cellFixedWidth = [UIScreen mainScreen].bounds.size.width;
/// 手动计算高度
[section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
    return 100 + item * 100;
}];
/// 或者可以自动计算高度  布局约束好  数据填充完
section.autoHeightFixedWidth = YES;

/// 对应index需要返回的reusedId来取对应的cell
[section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
    return [section.cellElements firstObject].reuseIdentifier;
}];

#pragma mark --- 标签分组
/// 是否是单行滚动
section.isSingleLineCanScroll = YES;
/// 不是单行的话  可以限制最大行数
section.maxLine = 6;
/// 固定每一个高度
section.cellFixedHeight = 40;
/// 返回对应的宽度
[section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
    return item * 20 + 100;
}];

#pragma mark --- 填充布局分组
/// 需返回大小  插入到合适的位置
[section setSizeBlock:^CGSize(id  _Nonnull section, NSInteger item) {
    switch (item) {
        case 2:
            return CGSizeMake(150, 140.32);
        case 5:
            return CGSizeMake((self.view.frame.size.width-20-150)/2, 70.19);
        case 8:
        case 11:
            return CGSizeMake(100, 240);
        case 10:
            return CGSizeMake(self.view.frame.size.width-20-200, 140);
        case 9:
        case 12:
            return CGSizeMake(self.view.frame.size.width-20-100, 100);
        case 0:
        case 1:
        case 3:
        case 4:
            return CGSizeMake((self.view.frame.size.width-20-150)/4, 70.13);
        default:
            return CGSizeMake((self.view.frame.size.width-20-150)/4, 70.19);
    }
}];

#pragma mark --- 特斯拉组件的使用说明  内部都是FMCollectionLayoutView的组合
/// 创建组件 遵守代理并实现必须的方法
FMTeslaLayoutView *multi = [[FMTeslaLayoutView alloc] init];
multi.delegate = self;
multi.dataSource = self;
[self.view addSubview:multi];
/// 悬停头部的最小高度 伸缩动画用
- (CGFloat)shareSuspensionMinHeightWithTesla:(FMTeslaLayoutView *)tesla{
    return 70;
}
/// 即将创建FMCollectionLayoutView  每一个分页只创建一个  懒加载
- (void)tesla:(FMTeslaLayoutView *)tesla willCreateLayoutViewWithIndex:(NSInteger)index{
    NSLog(@"willCreateLayoutViewWithIndex %ld", (long)index);
}
// 已创建FMCollectionLayoutView
- (void)tesla:(FMTeslaLayoutView *)tesla didCreatedLayoutViewWithIndex:(NSInteger)index layoutView:(FMCollectionLayoutView *)layoutView{
    NSLog(@"didCreatedLayoutViewWithIndex %ld", (long)index);
}
// 分页滚动到哪一页  并返回当前页的layoutView
- (void)tesla:(FMTeslaLayoutView *)tesla didScrollEnd:(NSInteger)index currentLayoutView:(nonnull FMCollectionLayoutView *)layoutView{
    [self.navTitleView selectWithIndex:index];
}
/// 分页个数
- (NSInteger)numberOfScreenInTesla:(nonnull FMTeslaLayoutView *)tesla {
    return 4;
}
/// 对应页面的view需要展示的Sections集合
- (nonnull NSMutableArray<FMLayoutBaseSection *> *)tesla:(nonnull FMTeslaLayoutView *)tesla sectionsInScreenIndex:(NSInteger)screenIndex {
    return [self.sections mutableCopy];
}
/// 头部共享的集合
- (NSArray<FMLayoutBaseSection *> *)shareSectionsInTesla:(FMTeslaLayoutView *)tesla{
    return self.shareSections;
}

```
有使用问题，欢迎联系我随时交流，QQ:847881570, 能Star一下的话，感激不尽
