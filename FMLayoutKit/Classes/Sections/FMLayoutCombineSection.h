//
//  FMLayoutCombineSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/12.
//

#import "FMLayoutBaseSection.h"

NS_ASSUME_NONNULL_BEGIN
///可以将不同Cell, 不同的布局方式,  放到同一个分组去合并,只合并cell, 如果子分组有头部和底部讲被忽略,合并分组的头部与底部不影响配置, cell的点击事件已经在init方法中配置block分发到子分组上  合并分组不支持拖拽排序  想要支持  可以继承自该类重写canLongPressExchange的get方法  并实现- (void)exchangeObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
@interface FMLayoutCombineSection : FMLayoutBaseSection
@property(nonatomic, readonly)NSArray<FMLayoutBaseSection *> *subSections;
+ (instancetype)combineSections:(NSArray<FMLayoutBaseSection *> *)sections;
- (void)appendSection:(FMLayoutBaseSection *)section;
- (void)insetSection:(FMLayoutBaseSection *)section atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
