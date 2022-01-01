//
//  FMLayoutLabelSection.h
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/4/8.
//

#import "FMLayoutDynamicSection.h"
#import "FMLayoutElement.h"
NS_ASSUME_NONNULL_BEGIN

///返回cell大小的block
typedef CGFloat(^FMLayoutItemWidthBlock)(id section, NSInteger item);

///当到第多少个的时候超出最大行  可移除数据处理  itemDatas会清理 否则frame为zero
typedef CGFloat(^FMLayoutOverItemBlock)(id section, NSInteger item);

///标签式布局   根据文本伸缩布局  宽度不够  换行    适用于历史搜索记录  sku选择等样式
@interface FMLayoutLabelSection : FMLayoutDynamicSection
///最大行数  超出讲不显示  纵向布局时生效
@property(nonatomic, assign)NSInteger maxLine;
///cell固定的高度
@property(nonatomic, assign)CGFloat cellFixedHeight;
///cell最大宽度  不设置的话  就是collection的宽度减去左右分组内边距
@property(nonatomic, assign)CGFloat cellMaxWidth;
///block返回手动计算的宽度
@property(nonatomic, copy)FMLayoutItemWidthBlock widthBlock;
///block返回手动计算的宽度
@property(nonatomic, copy)FMLayoutOverItemBlock overItemBlock;

@end

NS_ASSUME_NONNULL_END
