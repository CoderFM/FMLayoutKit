//
//  FMCollectionHorizontalLayout.h
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/2.
//

#import <UIKit/UIKit.h>
#import "FMLayoutFixedSection.h"
#import "FMLayoutLabelSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCollectionHorizontalLayout : UICollectionViewLayout

@property(nonatomic, weak)FMLayoutBaseSection *section;

@end

NS_ASSUME_NONNULL_END
