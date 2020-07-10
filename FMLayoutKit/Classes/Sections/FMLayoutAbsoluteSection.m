//
//  FMLayoutAbsoluteSection.m
//  FMCollectionLayout
//
//  Created by 周发明 on 2020/6/9.
//

#import "FMLayoutAbsoluteSection.h"
#import "FMCollectionLayoutAttributes.h"

@interface FMLayoutAbsoluteSection ()

@property(nonatomic, assign)CGFloat maxSize;

@end

@implementation FMLayoutAbsoluteSection

- (id)copyWithZone:(NSZone *)zone{
    FMLayoutAbsoluteSection *section = [super copyWithZone:zone];
    section.frameBlock = [self.frameBlock copy];
    return section;
}

- (void)prepareItems{
    self.maxSize = self.handleType == FMLayoutHandleTypeOlnyChangeOffset ? [self.columnSizes[@0] floatValue]:0;
    [super prepareItems];
    self.columnSizes[@0] = @(self.maxSize);
}

- (FMCollectionLayoutAttributes *)getItemAttributesWithIndex:(NSInteger)j{
    FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:self.indexPath.section]];
    CGRect frame = self.frameBlock?self.frameBlock(self, j): CGRectZero;
    frame.origin.y += self.firstItemStartY;
    frame.origin.x += self.firstItemStartX;
    itemAttr.frame = frame;
    
    if (self.direction == FMLayoutDirectionVertical) {
        if (self.maxSize < frame.origin.y + frame.size.height) {
            self.maxSize = frame.origin.y + frame.size.height;
            self.maxSize -= self.firstItemStartY;
        }
    } else {
        if (self.maxSize < frame.origin.x + frame.size.width) {
            self.maxSize = frame.origin.x + frame.size.width;
            self.maxSize -= self.firstItemStartX;
        }
    }
    return itemAttr;
}

- (CGFloat)crossSingleSectionSize{
    if (self.direction == FMLayoutDirectionHorizontal) {
        CGFloat maxSize = 0;
        for (int j = 0; j < self.itemCount; j++) {
            CGRect frame = self.frameBlock?self.frameBlock(self, j): CGRectZero;
            if (maxSize < frame.origin.y + frame.size.height) {
                maxSize = frame.origin.y + frame.size.height;
            }
        }
        return maxSize;
    } else {
        CGFloat maxSize = 0;
        for (int j = 0; j < self.itemCount; j++) {
            CGRect frame = self.frameBlock?self.frameBlock(self, j): CGRectZero;
            if (maxSize < frame.origin.x + frame.size.width) {
                maxSize = frame.origin.x + frame.size.width;
            }
        }
        return maxSize;
    }
}

@end
