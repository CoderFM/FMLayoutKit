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
            cell.layer.affineTransform = CGAffineTransformMakeScale(0.8 + (1 - (fabs(progress))) * 0.2, 0.8 + (1 - (fabs(progress))) * 0.2);
        });
        FMLayoutCrossTransformAdd(FMLayoutCrossTransformCrooked, ^(UICollectionViewCell * _Nonnull cell, CGFloat progress) {
            CATransform3D transform;
            if (progress < 0) {
                transform = CATransform3DMakeRotation(M_PI_4 * 0.5 * (fabs(progress)), 1, 1, 0);
            } else if (progress > 0) {
                transform = CATransform3DMakeRotation(M_PI_4 * 0.5 * (fabs(progress)), -1, 1, 0);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (self.transformType == FMLayoutCrossTransformNone) {
        return;
    }
    FMLayoutCrossTransformBlock block = FMLayoutCrossTransformFromType(self.transformType);
    if (block) {
        CGPoint globalCenter = scrollView.window.center;
        NSArray *cells = [(UICollectionView *)scrollView visibleCells];
        for (UICollectionViewCell *cell in cells) {
            CGPoint cellGlobalCenter = [cell convertPoint:cell.center toView:cell.window];
            CGFloat progress = (cellGlobalCenter.x - cell.frame.origin.x - globalCenter.x) / globalCenter.x;
            if (progress < -1) {
                progress = -1;
            }
            if (progress > 1) {
                progress = 1;
            }
            block(cell, progress);
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
    CGPoint globalCenter = scrollView.window.center;
    UICollectionViewCell *lastCell = nil;
    CGFloat minProgress = 1;
    NSArray *cells = [(UICollectionView *)scrollView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        CGPoint cellGlobalCenter = [cell convertPoint:cell.center toView:cell.window];
        CGFloat progress = (cellGlobalCenter.x - cell.frame.origin.x - globalCenter.x) / globalCenter.x;
        if (fabs(progress) < minProgress) {
            minProgress = fabs(progress);
            lastCell = cell;
        }
    }
    NSIndexPath *indexPath = [(UICollectionView *)scrollView indexPathForCell:lastCell];
    [(UICollectionView *)scrollView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


@end
