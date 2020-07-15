//
//  FMLayoutCrossTransformSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/15.
//

#import "FMLayoutCrossTransformSection.h"

static NSMutableDictionary *__FMLayoutCrossTransforms;
FMLayoutCrossTransformBlock FMLayoutCrossTransformFromType(FMLayoutCrossTransformType type) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __FMLayoutCrossTransforms = [NSMutableDictionary dictionary];
        FMLayoutCrossTransformAdd(FMLayoutCrossTransformScale, ^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
            cell.layer.affineTransform = CGAffineTransformMakeScale(0.9 + (1 - (fabs(progress))) * 0.1, 0.9 + (1 - (fabs(progress))) * 0.1);
        });
        FMLayoutCrossTransformAdd(FMLayoutCrossTransformCrooked, ^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
            CATransform3D transform;
            if (progress < 0) {
                transform = CATransform3DMakeRotation(M_PI_4 * 0.5 * (fabs(progress)), 1, 1, 0);
            } else if (progress > 0) {
                transform = CATransform3DMakeRotation(M_PI_4 * 0.5 * (fabs(progress)), -1, 1, 0);
            } else {
                transform = CATransform3DIdentity;
            }
            transform.m34 = 1/500.0;
            cell.layer.allowsEdgeAntialiasing = YES;
            cell.layer.transform = transform;
        });
    });
    return __FMLayoutCrossTransforms[@(type)];
}

void FMLayoutCrossTransformAdd(FMLayoutCrossTransformType type, FMLayoutCrossTransformBlock block){
    __FMLayoutCrossTransforms[@(type)] = [block copy];
}

@implementation FMLayoutCrossTransformSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConfigureCollectionView:^(UICollectionView * _Nonnull collectionView, FMLayoutCrossSection * _Nonnull hSection) {
            collectionView.decelerationRate = 0;
            collectionView.alwaysBounceHorizontal = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView layoutIfNeeded];
                [collectionView.delegate scrollViewDidScroll:collectionView];
            });
        }];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (self.transformType == FMLayoutCrossTransformNone && self.transformBlock == nil) {
        return;
    }
    FMLayoutCrossTransformBlock block = self.transformBlock ?: FMLayoutCrossTransformFromType(self.transformType);
    if (block) {
        
        NSArray *cells = [(UICollectionView *)scrollView visibleCells];
        for (UICollectionViewCell *cell in cells) {
            block(cell, [self progressCell:cell scrollView:scrollView]);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollToCenter:scrollView];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
            [self scrollToCenter:scrollView];
        });
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollToCenter:scrollView];
}

- (void)scrollToCenter:(UIScrollView *)scrollView{
    UICollectionViewCell *lastCell = nil;
    CGFloat minProgress = 1.01;
    NSArray *cells = [(UICollectionView *)scrollView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        if (lastCell == nil) {
            lastCell = cell;
        }
        CGFloat progress = [self progressCell:cell scrollView:scrollView];
        if (fabs(progress) < minProgress) {
            minProgress = fabs(progress);
            lastCell = cell;
        }
    }
    NSIndexPath *indexPath = [(UICollectionView *)scrollView indexPathForCell:lastCell];
    if (indexPath) {
        [(UICollectionView *)scrollView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (CGFloat)progressCell:(UICollectionViewCell *)cell scrollView:(UIScrollView *)scrollView{
    CGPoint globalCenter = scrollView.center;
    CGPoint cellGlobalCenter = cell.center;
    CGFloat progress = (cellGlobalCenter.x - scrollView.contentOffset.x - globalCenter.x) / globalCenter.x;
    if (progress < -1) {
        progress = -1;
    }
    if (progress > 1) {
        progress = 1;
    }
    return progress;
}

@end
