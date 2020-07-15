//
//  FMLayoutCrossTransformSection.h
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/15.
//

#import "FMLayoutCrossSection.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FMLayoutCrossTransformType) {
    ///什么都不做
    FMLayoutCrossTransformNone,
    ///缩小0.9 + 0.1*进度
    FMLayoutCrossTransformScale,
    ///简拼App首页样式  M_PI_4 * 0.5 * 进度
    FMLayoutCrossTransformCrooked,
};
///Cell是需要做处理的cell,  progress是指cell中心点到屏幕边缘移动的进度  -1 ~ 1   0为在最中间  -1在左边  1在右边
typedef void(^FMLayoutCrossTransformBlock)(UICollectionViewCell *cell, CGFloat progress);

extern void FMLayoutCrossTransformAdd(FMLayoutCrossTransformType type, FMLayoutCrossTransformBlock block);

///当前仅针对横向做适配  更多的动画  可以自己通过FMLayoutCrossTransformAdd增加
@interface FMLayoutCrossTransformSection : FMLayoutCrossSection
///形变类型
@property(nonatomic, assign)FMLayoutCrossTransformType transformType;
///如果有该Block  则优先执行此block
@property(nonatomic, copy)FMLayoutCrossTransformBlock transformBlock;

@end

NS_ASSUME_NONNULL_END
