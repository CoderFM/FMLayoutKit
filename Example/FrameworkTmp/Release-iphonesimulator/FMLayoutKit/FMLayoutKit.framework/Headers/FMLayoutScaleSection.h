//
//  FMLayoutScaleSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/20.
//

#import "FMLayoutDynamicSection.h"

NS_ASSUME_NONNULL_BEGIN
///支持两种设置固定大小的方式   一种直接给数组sizeNums  一种给比例字符串scales  后设置的生效
@interface FMLayoutScaleSection : FMLayoutDynamicSection
/// 纵向布局  则是宽度比例  横向布局  则是高度比例  例如纵向布局时该值为:  1:2:3  则就是3列  宽度比为剩下的值的比例  仅支持当前样式  可以是小数值 但不能为非数值类型
@property(nonatomic, copy)NSString *scales;
///每一列的固定大小 如:@[@100, @200] 则表示两列 一个固定宽度为100  另外一列为200  共两列
@property(nonatomic, strong)NSArray<NSNumber *> *sizeNums;
@end

NS_ASSUME_NONNULL_END
