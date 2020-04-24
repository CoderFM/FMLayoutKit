//
//  FMTeslaLayoutView.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/8.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMTeslaLayoutView.h"
#import "FMCollectionLayoutView.h"

@interface FM_ScrollView : UIScrollView

@property(nonatomic, copy)BOOL(^panGesCanBegin)(CGPoint panPoint);

@end

@implementation FM_ScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint panPoint = [pan locationInView:self];
        if (self.panGesCanBegin) {
            return self.panGesCanBegin(panPoint);
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

@interface FMTeslaLayoutView ()<FMCollectionLayoutViewConfigurationDelegate, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak)FMLayoutBaseSection *suspensionAlwaysHeader;
@property(nonatomic, weak)FM_ScrollView *scrollView;

@property(nonatomic, strong)FMCollectionLayoutView *shareLayoutView;
@property(nonatomic, weak)FMCollectionLayoutView *currentLayoutView;

@property(nonatomic, strong)NSArray *layoutViews;

@property(nonatomic, assign)BOOL isLayoutSubView;
@property(nonatomic, assign)BOOL isLoadSubView;


@property(nonatomic, assign)CGRect shareOriginalFrame;

@end

@implementation FMTeslaLayoutView

- (void)reLoadSubViews{
    if (self.isLayoutSubView && self.isLoadSubView) {
        self.isLoadSubView = NO;
        for (UIView *view in self.layoutViews) {
            [view removeFromSuperview];
        }
        [self loadSubViews];
    }
}

- (void)reloadData{
    [self.currentLayoutView reloadData];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    CGFloat offsetX = index * self.scrollView.bounds.size.width;
    [self scrollStart];
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    if (!animated) {
        [self scrollEnd];
    }
}

- (void)dealloc{
    self.currentLayoutView = nil;
}

- (FM_ScrollView *)scrollView{
    if (_scrollView == nil) {
        FM_ScrollView *scroll = [[FM_ScrollView alloc] init];
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        scroll.bounces = NO;
        [self addSubview:scroll];
        __weak typeof(self) weakSelf = self;
        [scroll setPanGesCanBegin:^BOOL(CGPoint panPoint) {
            CGFloat offsetY = weakSelf.currentLayoutView.contentOffset.y;
            return panPoint.y > -offsetY;
        }];
        _scrollView = scroll;
    }
    return _scrollView;
}

- (FMCollectionLayoutView *)shareLayoutView{
    if (_shareLayoutView == nil) {
        _shareLayoutView = [[FMCollectionLayoutView alloc] init];
        _shareLayoutView.backgroundColor = [UIColor clearColor];
        _shareLayoutView.delegate = self;
        _shareLayoutView.configuration = self;
    }
    return _shareLayoutView;
}

- (void)setCurrentLayoutView:(FMCollectionLayoutView *)currentLayoutView{
    if (_currentLayoutView) {
        [_currentLayoutView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _currentLayoutView = currentLayoutView;
    if (currentLayoutView) {
        [currentLayoutView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setShareSections:(NSMutableArray<FMLayoutBaseSection *> *)shareSections{
    _shareSections = shareSections;
    self.suspensionAlwaysHeader = shareSections.count > 0 ? ([shareSections lastObject].header.type == FMSupplementaryTypeSuspensionAlways ? [shareSections lastObject] :nil) : nil;
}

- (void)setMultiSections:(NSArray<NSMutableArray<FMLayoutBaseSection *> *> *)multiSections{
    _multiSections = multiSections;
    if (self.isLayoutSubView) {
        [self loadSubViews];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)loadSubViews{
    NSMutableArray *arrM = [NSMutableArray array];
    self.shareLayoutView.frame = self.bounds;
    [self addSubview:self.shareLayoutView];
    [self.shareLayoutView.layout setSections:self.shareSections];
    [self.shareLayoutView.layout handleSections];
    CGFloat shareHeight = [self.shareSections lastObject].sectionHeight + [self.shareSections lastObject].sectionOffset;
    self.shareLayoutView.frame = CGRectMake(0, 0, self.bounds.size.width, shareHeight);
    
    NSInteger nums = self.multiSections.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * nums, 0);
    for (int i = 0; i<nums; i++) {
        FMCollectionLayoutView *collectionView = [[FMCollectionLayoutView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width * i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        collectionView.configuration = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.bounces = YES;
        collectionView.alwaysBounceVertical = YES;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [self.scrollView addSubview:collectionView];
        
        NSMutableArray *sections = [self.multiSections[i] mutableCopy];
//        FMLayoutBaseSection *section = [[FMLayoutBaseSection alloc] init];
//        section.hasHanble = YES;
//        section.sectionHeight = shareHeight;
//        [sections insertObject:section atIndex:0];
        [collectionView.layout setFirstSectionOffsetY:shareHeight];
        [collectionView.layout setSections:sections];
        [collectionView reloadData];
        if (self.currentLayoutView == nil) {
            self.currentLayoutView = collectionView;
        }
        [arrM addObject:collectionView];
    }
    self.layoutViews = [arrM copy];
    [self.shareLayoutView removeFromSuperview];
    [self.currentLayoutView addSubview:self.shareLayoutView];
    [self.shareLayoutView reloadData];
    self.isLoadSubView = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.isLayoutSubView = YES;
    if (!self.isLoadSubView) {
        [self loadSubViews];
    }
}

- (void)scrollStart{
    if (!self.scrollView.tracking) {
        self.userInteractionEnabled = NO;
    }
    [self.shareLayoutView removeFromSuperview];
    CGRect frame = self.shareLayoutView.frame;
    frame.origin.y =  - self.currentLayoutView.contentOffset.y;
    CGFloat minY = self.suspensionAlwaysHeader.sectionHeight - self.shareLayoutView.frame.size.height;
    if (frame.origin.y < minY) {
        frame.origin.y = minY;
    }
    self.shareLayoutView.frame = frame;
    [self addSubview:self.shareLayoutView];
}

- (void)scrollEnd{
    self.userInteractionEnabled = YES;
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.currentLayoutView = self.layoutViews[index];
    [self.shareLayoutView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(tesla:didScrollEnd:)]) {
        [self.delegate tesla:self didScrollEnd:index];
    }
    
    CGFloat y = self.currentLayoutView.contentOffset.y;
    if (y < self.shareLayoutView.frame.size.height-self.suspensionAlwaysHeader.sectionHeight) {
        CGRect frame = self.shareLayoutView.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.shareLayoutView.frame = frame;
    } else {
        CGRect frame = self.shareLayoutView.frame;
        frame.origin.y = y + self.suspensionAlwaysHeader.sectionHeight - self.shareLayoutView.frame.size.height;
        frame.origin.x = 0;
        self.shareLayoutView.frame = frame;
    }
    [self.currentLayoutView addSubview:self.shareLayoutView];
}

#pragma mark -------  FMCollectionLayoutView configuration  delegate
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(tesla:configurationCell:indexPath:isShare:multiIndex:layoutView:)]) {
        BOOL share;
        NSIndexPath *lastIndexPath = indexPath;
        NSInteger multiIndex = 0;
        if (layoutView == self.shareLayoutView) {
            share = YES;
        } else {
            share = NO;
            multiIndex = [self.layoutViews indexOfObject:layoutView];
            lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
        }
        [self.dataSource tesla:self configurationCell:cell indexPath:lastIndexPath isShare:share multiIndex:multiIndex layoutView:layoutView];
    }
}
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationHeader:(UICollectionReusableView *)header indexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(tesla:configurationHeader:indexPath:isShare:multiIndex:layoutView:)]) {
        BOOL share;
        NSIndexPath *lastIndexPath = indexPath;
        NSInteger multiIndex = 0;
        if (layoutView == self.shareLayoutView) {
            share = YES;
        } else {
            share = NO;
            multiIndex = [self.layoutViews indexOfObject:layoutView];
            lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
        }
        [self.dataSource tesla:self configurationHeader:header indexPath:lastIndexPath isShare:share multiIndex:multiIndex layoutView:layoutView];
    }
}
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationFooter:(UICollectionReusableView *)footer indexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(tesla:configurationFooter:indexPath:isShare:multiIndex:layoutView:)]) {
        BOOL share;
        NSIndexPath *lastIndexPath = indexPath;
        NSInteger multiIndex = 0;
        if (layoutView == self.shareLayoutView) {
            share = YES;
        } else {
            share = NO;
            multiIndex = [self.layoutViews indexOfObject:layoutView];
            lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
        }
        [self.dataSource tesla:self configurationFooter:footer indexPath:lastIndexPath isShare:share multiIndex:multiIndex layoutView:layoutView];
    }
}
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationSectionBg:(UICollectionReusableView *)bg indexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(tesla:configurationBg:indexPath:isShare:multiIndex:layoutView:)]) {
        BOOL share;
        NSIndexPath *lastIndexPath = indexPath;
        NSInteger multiIndex = 0;
        if (layoutView == self.shareLayoutView) {
            share = YES;
        } else {
            share = NO;
            multiIndex = [self.layoutViews indexOfObject:layoutView];
            lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
        }
        [self.dataSource tesla:self configurationBg:bg indexPath:lastIndexPath isShare:share multiIndex:multiIndex layoutView:layoutView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tesla:didSelectIndexPath:isShare:multiIndex:layoutView:)]) {
        BOOL share;
        NSIndexPath *lastIndexPath = indexPath;
        NSInteger multiIndex = 0;
        if (collectionView == self.shareLayoutView) {
            share = YES;
        } else {
            share = NO;
            multiIndex = [self.layoutViews indexOfObject:collectionView];
            lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
        }
        [self.delegate tesla:self didSelectIndexPath:lastIndexPath isShare:share multiIndex:multiIndex layoutView:(FMCollectionLayoutView *)collectionView];
    }
}

#pragma mark -------  observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    if (contentOffset.y < self.shareLayoutView.frame.size.height-self.suspensionAlwaysHeader.sectionHeight) {
        for (FMCollectionLayoutView *coll in self.layoutViews) {
            if (coll != self.currentLayoutView) {
                coll.contentOffset = contentOffset;
            } else {
                CGRect frame = self.shareLayoutView.frame;
                frame.origin.y = 0;
                self.shareLayoutView.frame = frame;
            }
        }
    } else {
        for (FMCollectionLayoutView *coll in self.layoutViews) {
            if (coll != self.currentLayoutView) {
                if (coll.contentOffset.y < self.shareLayoutView.frame.size.height-self.suspensionAlwaysHeader.sectionHeight) {
                    contentOffset.y = self.shareLayoutView.frame.size.height-self.suspensionAlwaysHeader.sectionHeight;
                    coll.contentOffset = contentOffset;
                }
            } else {
                CGRect frame = self.shareLayoutView.frame;
                frame.origin.y = contentOffset.y - self.shareLayoutView.frame.size.height+self.suspensionAlwaysHeader.sectionHeight;
                self.shareLayoutView.frame = frame;
            }
        }
    }
}

#pragma mark -------  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        if ([self.delegate respondsToSelector:@selector(tesla:scrollViewDidScroll:)]) {
            [self.delegate tesla:self scrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self scrollStart];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self scrollEnd];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollEnd];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self scrollEnd];
    }
}

@end
