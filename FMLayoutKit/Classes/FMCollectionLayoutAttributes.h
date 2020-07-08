//
//  FMCollectionLayoutAttributes.h
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/25.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLayoutBaseSection.h"
NS_ASSUME_NONNULL_BEGIN

@interface FMCollectionLayoutAttributes : UICollectionViewLayoutAttributes

@property(nonatomic, assign)FMLayoutDirection direction;

+ (instancetype)headerAttributesWithSection:(FMLayoutBaseSection *)section;
- (instancetype)updateHeaderAttributesWithSection:(FMLayoutBaseSection *)section;

+ (instancetype)suspensionShowHeaderAttributes:(FMLayoutBaseSection *)section;

+ (instancetype)footerAttributesWithSection:(FMLayoutBaseSection *)section;
- (instancetype)updateFooterAttributesWithSection:(FMLayoutBaseSection *)section;

+ (instancetype)bgAttributesWithSection:(FMLayoutBaseSection *)section;
- (instancetype)updateBgAttributesWithSection:(FMLayoutBaseSection *)section;

- (void)_onlyUpdateOffsetWith:(FMLayoutBaseSection *)section;

@end

NS_ASSUME_NONNULL_END
