//
//  FMCollectionViewLayout.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLayoutBaseSection.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryBackground.h"

typedef NS_ENUM(NSUInteger, FMLayoutHeadersSuspensionType) {
    FMLayoutHeadersSuspensionTypeOverlap,
    FMLayoutHeadersSuspensionTypeSort
};

NS_ASSUME_NONNULL_BEGIN
@interface FMCollectionViewLayout : UICollectionViewLayout
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;
///底部固定边距   跟section的inset无关  contentSize会自动加上去
@property(nonatomic, assign)CGFloat fixedBottomMargin;
@property(nonatomic, assign)BOOL reLayoutOlnyChanged;
@property(nonatomic, assign)CGFloat minContentSizeHeight;
@property(nonatomic, assign)CGFloat firstSectionOffsetY;
- (void)handleSections;
@end

NS_ASSUME_NONNULL_END
