//
//  FMCollectionLayoutAttributes.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/3/25.
//  Copyright © 2020 ZhouFaMing. All rights reserved.
//

#import "FMCollectionLayoutAttributes.h"
#import "FMLayoutFooter.h"
#import "FMLayoutHeader.h"
#import "FMLayoutBackground.h"

@implementation FMCollectionLayoutAttributes

+ (instancetype)headerAttributesWithSection:(FMLayoutBaseSection *)section{
    if (!section.header) {
        return nil;
    }
    FMCollectionLayoutAttributes *header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:section.indexPath];
    header.direction = section.direction;
    if (header.direction == FMLayoutDirectionVertical) {
        
        [section.header updateHeightWithCollection:section.collectionView indexPath:section.indexPath maxWidth:section.collectionView.frame.size.width - section.sectionInset.left- section.header.inset.left - section.sectionInset.right - section.header.inset.right];
        
        header.frame = CGRectMake(section.sectionInset.left + section.header.inset.left, section.sectionInset.top + section.header.inset.top + section.sectionOffset, section.collectionView.frame.size.width - section.sectionInset.left- section.header.inset.left - section.sectionInset.right - section.header.inset.right, section.header.size);
    } else {
        header.frame = CGRectMake(section.sectionInset.left + section.header.inset.left + section.sectionOffset, section.sectionInset.top + section.header.inset.top,section.header.size, section.collectionView.frame.size.height - section.sectionInset.top- section.header.inset.top - section.sectionInset.bottom - section.header.inset.bottom);
    }
    header.zIndex = section.header.zIndex;
    return header;
}

- (instancetype)updateHeaderAttributesWithSection:(FMLayoutBaseSection *)section{
    self.indexPath = section.indexPath;
    [self _onlyUpdateOffsetWith:section];
    return self;
}

+ (instancetype)suspensionShowHeaderAttributes:(FMLayoutBaseSection *)section{
    if (section.direction == FMLayoutDirectionVertical) {
        if (section.header.type == FMLayoutHeaderTypeSuspension) {
            CGFloat columnMaxHeight = [section getColumnMaxHeight];
            CGFloat itemMaxHeight = section.sectionOffset + section.sectionInset.top + section.header.size + section.header.lastMargin + columnMaxHeight;
            if (section.collectionView.contentOffset.y > section.sectionOffset + section.sectionInset.top && section.collectionView.contentOffset.y < itemMaxHeight - section.header.size) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.y = section.collectionView.contentOffset.y;
                show.frame = frame;
                return show;
            } else if (section.collectionView.contentOffset.y >= itemMaxHeight - section.header.size) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.y = itemMaxHeight - section.header.size;
                show.frame = frame;
                return show;
            } else {
                return section.headerAttribute;
            }
        }
        if (section.header.type == FMLayoutHeaderTypeSuspensionAlways) {
            if (section.collectionView.contentOffset.y > section.sectionOffset + section.sectionInset.top - section.header.suspensionTopMargin) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.y = section.collectionView.contentOffset.y + section.header.suspensionTopMargin;
                show.frame = frame;
                return show;
            } else {
                if (section.header.isStickTop) {///黏在顶部
                    if (section.collectionView.contentOffset.y > 0) {
                        return section.headerAttribute;
                    }
                    FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                    CGRect frame = show.frame;
                    frame.origin.y = section.collectionView.contentOffset.y + frame.origin.y;
                    show.frame = frame;
                    return show;
                } else {
                    return section.headerAttribute;
                }
            }
        }
        if (section.header.type == FMLayoutHeaderTypeSuspensionBigger && section.indexPath.section == 0) {
            FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
            CGFloat offsetY = section.collectionView.contentOffset.y;
            if (offsetY < CGRectGetHeight(show.frame)) {
                CGRect frame = show.frame;
                
                frame.origin.y += offsetY;
                frame.size.height -= offsetY;
                if (section.header.minSize > 0) {
                    if (frame.size.height < section.header.minSize) {
                        frame.size.height = section.header.minSize;
                    }
                }
                show.frame = frame;
                
                return show;
            } else {
                CGRect frame = show.frame;
                
                if (section.header.minSize > 0) {
                    frame.origin.y += offsetY;
                    frame.size.height -= CGRectGetHeight(show.frame);
                    if (section.header.minSize > 0) {
                        if (frame.size.height < section.header.minSize) {
                            frame.size.height = section.header.minSize;
                        }
                    }
                } else {
                    frame.origin.y += CGRectGetHeight(show.frame);
                    frame.size.height -= CGRectGetHeight(show.frame);
                }
                
                show.frame = frame;
                return show;
            }
        }
    } else {
        if (section.header.type == FMLayoutHeaderTypeSuspension) {
            CGFloat columnMaxHeight = [section getColumnMaxHeight];
            CGFloat itemMaxHeight = section.sectionOffset + section.sectionInset.left + section.header.size + section.header.lastMargin + columnMaxHeight;
            if (section.collectionView.contentOffset.x > section.sectionOffset + section.sectionInset.left && section.collectionView.contentOffset.x < itemMaxHeight - section.header.size) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.x = section.collectionView.contentOffset.x;
                show.frame = frame;
                return show;
            } else if (section.collectionView.contentOffset.x >= itemMaxHeight - section.header.size) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.x = itemMaxHeight - section.header.size;
                show.frame = frame;
                return show;
            } else {
                return section.headerAttribute;
            }
        }
        if (section.header.type == FMLayoutHeaderTypeSuspensionAlways) {
            if (section.collectionView.contentOffset.x > section.sectionOffset + section.sectionInset.left - section.header.suspensionTopMargin) {
                FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                CGRect frame = show.frame;
                frame.origin.x = section.collectionView.contentOffset.x + section.header.suspensionTopMargin;
                show.frame = frame;
                return show;
            } else {
                if (section.header.isStickTop) {///黏在顶部
                    if (section.collectionView.contentOffset.x > 0) {
                        return section.headerAttribute;
                    }
                    FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
                    CGRect frame = show.frame;
                    frame.origin.x = section.collectionView.contentOffset.x + frame.origin.x;
                    show.frame = frame;
                    return show;
                } else {
                    return section.headerAttribute;
                }
            }
        }
        if (section.header.type == FMLayoutHeaderTypeSuspensionBigger && section.indexPath.section == 0) {
            FMCollectionLayoutAttributes *show = [section.headerAttribute copy];
            CGFloat offsetX = section.collectionView.contentOffset.x;
            if (offsetX < CGRectGetWidth(show.frame)) {
                CGRect frame = show.frame;
                
                frame.origin.x += offsetX;
                frame.size.width -= offsetX;
                if (section.header.minSize > 0) {
                    if (frame.size.width < section.header.minSize) {
                        frame.size.width = section.header.minSize;
                    }
                }
                show.frame = frame;
                
                return show;
            } else {
                CGRect frame = show.frame;
                
                if (section.header.minSize > 0) {
                    frame.origin.x += offsetX;
                    frame.size.width -= CGRectGetWidth(show.frame);
                    if (section.header.minSize > 0) {
                        if (frame.size.width < section.header.minSize) {
                            frame.size.width = section.header.minSize;
                        }
                    }
                } else {
                    frame.origin.x += CGRectGetWidth(show.frame);
                    frame.size.width -= CGRectGetWidth(show.frame);
                }
                
                show.frame = frame;
                return show;
            }
        }
    }
    return nil;
}


+ (instancetype)footerAttributesWithSection:(FMLayoutBaseSection *)section{
    if (!section.footer) {
        return nil;
    }
    FMCollectionLayoutAttributes *footer = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:section.indexPath];
    footer.direction = section.direction;
    if (footer.direction == FMLayoutDirectionVertical) {
        
        [section.footer updateHeightWithCollection:section.collectionView indexPath:section.indexPath maxWidth:section.collectionView.frame.size.width - section.sectionInset.left- section.footer.inset.left - section.sectionInset.right - section.footer.inset.right];
        
        footer.frame = CGRectMake(section.sectionInset.left + section.footer.inset.left, section.sectionOffset + section.sectionInset.top + section.footer.inset.top + section.header.size + section.header.lastMargin + [section getColumnMaxHeight] + section.footer.topMargin, section.collectionView.frame.size.width - section.sectionInset.left - section.footer.inset.left - section.sectionInset.right - section.footer.inset.right, section.footer.size);
    } else {
        CGFloat x = section.sectionOffset + section.sectionInset.left + section.header.inset.left + section.header.size + section.header.inset.right + section.header.lastMargin + [section getColumnMaxHeight] + section.footer.topMargin;
        CGFloat y = section.sectionInset.top + section.footer.inset.top;
        CGFloat height = section.collectionView.frame.size.height - section.sectionInset.top- section.footer.inset.top - section.sectionInset.bottom - section.footer.inset.bottom;
        footer.frame = CGRectMake(x, y,section.footer.size, height);
    }
    footer.zIndex = section.footer.zIndex;
    return footer;
}

- (instancetype)updateFooterAttributesWithSection:(FMLayoutBaseSection *)section{
    self.indexPath = section.indexPath;
    [self _onlyUpdateOffsetWith:section];
    return self;
}

+ (instancetype)bgAttributesWithSection:(FMLayoutBaseSection *)section{
    if (!section.background) {
        return nil;
    }
    FMCollectionLayoutAttributes *bgAttr = [self layoutAttributesForSupplementaryViewOfKind:section.background.elementKind withIndexPath:section.indexPath];
    bgAttr.direction = section.direction;
    if (bgAttr.direction == FMLayoutDirectionVertical) {
        bgAttr.frame = CGRectMake(section.background.inset.left, section.sectionOffset + section.background.inset.top, section.collectionView.frame.size.width - (section.background.inset.left + section.background.inset.right), section.sectionSize - (section.background.inset.top + section.background.inset.bottom));
    } else {
        bgAttr.frame = CGRectMake(section.sectionOffset + section.background.inset.left,  section.background.inset.top, section.sectionSize - (section.background.inset.left + section.background.inset.right) , section.collectionView.frame.size.height - (section.background.inset.top + section.background.inset.bottom));
    }
    bgAttr.zIndex = section.background.zIndex;
    return bgAttr;
}

- (instancetype)updateBgAttributesWithSection:(FMLayoutBaseSection *)section{
    self.indexPath = section.indexPath;
    [self _onlyUpdateOffsetWith:section];
    return self;
}

- (void)_onlyUpdateOffsetWith:(FMLayoutBaseSection *)section{
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (!CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
        transform = self.transform;
    }
    self.transform = CGAffineTransformIdentity;
    if (self.direction == FMLayoutDirectionVertical) {
        CGRect frame = self.frame;
        frame.origin.y += section.changeOffset;
        self.frame = frame;
    } else {
        CGRect frame = self.frame;
        frame.origin.x += section.changeOffset;
        self.frame = frame;
    }
    self.transform = transform;
}

@end
