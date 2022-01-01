//
//  FMLayoutAbsoluteSection.h
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/6/9.
//

#import "FMLayoutDynamicSection.h"

NS_ASSUME_NONNULL_BEGIN

typedef CGRect(^FMLayoutBaseSectionItemFrameBlock)(id section, NSInteger item);
///支持纵向插横向
@interface FMLayoutAbsoluteSection : FMLayoutDynamicSection

@property(nonatomic, copy)FMLayoutBaseSectionItemFrameBlock frameBlock;

@end

NS_ASSUME_NONNULL_END
