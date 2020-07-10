//
//  FMLayoutElement.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/4/1.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMLayoutElement.h"

@interface FMLayoutElement ()



@end

@implementation FMLayoutElement

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutElement *element = [[[self class] allocWithZone:zone] init];
    element.reuseIdentifier = self.reuseIdentifier;
    element.isNib = self.isNib;
    element.viewClass = self.viewClass;
    return element;
}

+ (instancetype)elementWithViewClass:(Class)vCalss{
    return [self elementWithViewClass:vCalss isNib:NO];
}

+ (instancetype)elementWithViewClass:(Class)vCalss isNib:(BOOL)isNib{
    return [self elementWithViewClass:vCalss isNib:isNib reuseIdentifier:NSStringFromClass(vCalss)];
}

+ (instancetype)elementWithViewClass:(Class)vCalss isNib:(BOOL)isNib reuseIdentifier:(NSString *)reuseIdentifier{
    FMLayoutElement *element = [[self alloc] init];
    element.viewClass = vCalss;
    element.isNib = isNib;
    element.reuseIdentifier = reuseIdentifier;
    return element;
}

- (void)registerElementWithCollection:(UICollectionView *)collectionView{
    if (self.isNib) {
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(self.viewClass) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:self.reuseIdentifier];
    } else {
        [collectionView registerClass:self.viewClass forCellWithReuseIdentifier:self.reuseIdentifier];
    }
}

@end
