//
//  FMCollectionViewLayout.h
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCollectionLayoutBaseSection.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryBackground.h"

NS_ASSUME_NONNULL_BEGIN
@interface FMCollectionViewLayout : UICollectionViewLayout
@property(nonatomic, strong)NSArray<FMCollectionLayoutBaseSection *> *sections;
@end

NS_ASSUME_NONNULL_END
