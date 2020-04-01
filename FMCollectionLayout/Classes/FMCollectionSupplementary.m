//
//  FMCollectionSupplementary.m
//  LiangXinApp
//
//  Created by 郑桂华 on 2020/3/20.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionSupplementary.h"

@interface FMCollectionSupplementary ()

@property(nonatomic, assign)BOOL isNib;

@end

@implementation FMCollectionSupplementary

+ (instancetype)supplementaryHeight:(CGFloat)height viewClass:(Class)vClass{
    return [self supplementaryHeight:height viewClass:vClass isNib:NO];
}

+ (instancetype)supplementaryHeight:(CGFloat)height viewClass:(Class)vClass isNib:(BOOL)isNib{
    FMCollectionSupplementary *dec = [[self alloc] init];
    dec.height = height;
    dec.viewClass = vClass;
    dec.type = FMSupplementaryTypeFixed;
    dec.zIndex = FMSupplementaryZIndexFrontOfItem;
    dec.isNib = isNib;
    return dec;
}

- (void)registerWithCollectionView:(UICollectionView *)collectionView{
    if (self.isNib) {
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(self.viewClass) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:self.elementKind withReuseIdentifier:NSStringFromClass(self.viewClass)];
    } else {
        [collectionView registerClass:self.viewClass forSupplementaryViewOfKind:self.elementKind withReuseIdentifier:NSStringFromClass(self.viewClass)];
    }
}

@end
