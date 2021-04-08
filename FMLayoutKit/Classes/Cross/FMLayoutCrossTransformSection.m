//
//  FMLayoutCrossTransformSection.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2020/7/15.
//

#import "FMLayoutCrossTransformSection.h"

@implementation FMLayoutCrossTransformSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConfigureCollectionView:^(UICollectionView * _Nonnull collectionView, FMLayoutCrossSection * _Nonnull hSection) {
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
            collectionView.alwaysBounceHorizontal = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView layoutIfNeeded];
                [collectionView.delegate scrollViewDidScroll:collectionView];
            });
        }];
    }
    return self;
}

- (void)setTransformType:(FMLayoutCrossTransformType)transformType{
    _transformType = transformType;
    switch (transformType) {
        case FMLayoutCrossTransformScale:
        {
            [self setTransformBlock:^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
                cell.layer.affineTransform = CGAffineTransformMakeScale(0.9 + (1 - (fabs(progress))) * 0.1, 0.9 + (1 - (fabs(progress))) * 0.1);
            }];
        }
            break;
        case FMLayoutCrossTransformCrooked:
        {
            [self setTransformBlock:^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
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
            }];
        }
            break;
        case FMLayoutCrossTransformFold:
        {
            [self setTransformBlock:^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
                CATransform3D transform;
                if (progress < 0) {
                    cell.layer.anchorPoint = CGPointMake(0 + 0.5 * (1 - fabs(progress)), 0.5);
                    transform = CATransform3DMakeTranslation(-cell.bounds.size.width * 0.5 *  fabs(progress), 0, 0);
                    cell.layer.transform = transform;
                    
                    transform.m34 = 1.0/500;
                    transform = CATransform3DRotate(transform, M_PI_4 * fabs(progress), 0, -1, 0);
                } else {
                    cell.layer.anchorPoint = CGPointMake(1 - 0.5 * (1 - fabs(progress)), 0.5);
                    transform = CATransform3DMakeTranslation(cell.bounds.size.width * 0.5 * fabs(progress), 0, 0);
                    cell.layer.transform = transform;
                    
                    transform.m34 = 1.0/500;
                    transform = CATransform3DRotate(transform, M_PI_4 * fabs(progress), 0, 1, 0);
                }
                if (@available(iOS 13.0, *)) {
                    cell.transform3D = transform;
                } else {
                    cell.layer.transform = transform;
                }
            }];
        }
            break;
        default:
            self.transformBlock = nil;
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (self.transformBlock == nil) {
        return;
    }
    FMLayoutCrossTransformBlock block = self.transformBlock;
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
