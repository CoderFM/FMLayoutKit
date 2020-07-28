//
//  FMSupplementary.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMSupplementary.h"

@interface FMSupplementary ()

@end

@implementation FMSupplementary

- (id)copyWithZone:(NSZone *)zone{
    FMSupplementary *supp = [super copyWithZone:zone];
    supp.size = self.size;
    supp.zIndex = self.zIndex;
    supp.autoHeight = self.autoHeight;
    supp.configureDataAutoHeight = [self.configureDataAutoHeight copy];
    return supp;
}

+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass{
    return [self elementSize:size viewClass:vClass isNib:NO];
}

+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass isNib:(BOOL)isNib{
    return [self elementSize:size viewClass:vClass isNib:isNib reuseIdentifier:NSStringFromClass(vClass)];
}

+ (instancetype)elementSize:(CGFloat)size viewClass:(Class)vClass isNib:(BOOL)isNib reuseIdentifier:(NSString *)reuseIdentifier{
    FMSupplementary *dec = [super elementWithViewClass:vClass isNib:isNib reuseIdentifier:reuseIdentifier];
    dec.size = size;
    dec.zIndex = FMLayoutZIndexFrontOfItem;
    return dec;
}

- (void)registerElementWithCollection:(UICollectionView *)collectionView{
    if (self.isNib) {
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(self.viewClass) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:self.elementKind withReuseIdentifier:self.reuseIdentifier];
    } else {
        [collectionView registerClass:self.viewClass forSupplementaryViewOfKind:self.elementKind withReuseIdentifier:self.reuseIdentifier];
    }
}

- (UICollectionReusableView *)dequeueReusableViewWithCollection:(UICollectionView *)collectionView indexPath:(nonnull NSIndexPath *)indexPath{
    return [collectionView dequeueReusableSupplementaryViewOfKind:self.elementKind withReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
}

- (void)updateHeightWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath maxWidth:(CGFloat)maxWidth{
    if (self.autoHeight) {
        UICollectionReusableView *view;
        if (self.isNib) {
            view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.viewClass) owner:nil options:nil] lastObject];
        } else {
            view = [[self.viewClass alloc] init];
        }
        if (self.configureDataAutoHeight) {
            self.configureDataAutoHeight(view);
        }
        CGSize size = [view systemLayoutSizeFittingSize:CGSizeMake(maxWidth, MAXFLOAT)];
        self.size = size.height;
    }
}

@end
