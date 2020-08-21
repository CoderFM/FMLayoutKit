//
//  FMLayoutFillSection.h
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/4/11.
//

#import "FMLayoutDynamicSection.h"

NS_ASSUME_NONNULL_BEGIN

///返回cell大小的block
typedef CGSize(^FMLayoutItemSizeBlock)(id section, NSInteger item);
///支持纵向插横向  只可以上对齐以及左对齐
@interface FMLayoutFillSection : FMLayoutDynamicSection

@property(nonatomic, copy)FMLayoutItemSizeBlock sizeBlock;

@end

NS_ASSUME_NONNULL_END
