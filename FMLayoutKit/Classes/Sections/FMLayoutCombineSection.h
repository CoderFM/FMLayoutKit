//
//  FMLayoutCombineSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/12.
//

#import "FMLayoutBaseSection.h"

NS_ASSUME_NONNULL_BEGIN
///可以将不同Cell, 不同的布局方式,  放到同一个分组去合并,只合并cell, 如果子分组有头部和底部讲被忽略,合并分组的头部与底部不影响配置, cell的点击事件已经在init方法中配置block分发到子分组上
@interface FMLayoutCombineSection : FMLayoutBaseSection

+ (instancetype)combineSections:(NSArray<FMLayoutBaseSection *> *)sections;

@end

NS_ASSUME_NONNULL_END
