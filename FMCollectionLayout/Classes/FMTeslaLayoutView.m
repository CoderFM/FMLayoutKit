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

@property(nonatomic, strong)NSMutableArray<FMCollectionLayoutView *> *layoutViews;

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
        scroll.bounces = YES;
        scroll.alwaysBounceHorizontal = YES;
        scroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:scroll];
        __weak typeof(self) weakSelf = self;
        [scroll setPanGesCanBegin:^BOOL(CGPoint panPoint) {
            CGFloat offsetY = weakSelf.currentLayoutView.contentOffset.y;
            CGFloat topCanPanY = weakSelf.shareLayoutView.frame.size.height + weakSelf.shareLayoutView.frame.origin.y - offsetY;
            if (topCanPanY < weakSelf.suspensionAlwaysHeader.header.height) {
                topCanPanY = weakSelf.suspensionAlwaysHeader.header.height;
            }
            return panPoint.y > topCanPanY;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layoutViews = [NSMutableArray array];
    }
    return self;
}

- (void)loadSubViews{
    [self.layoutViews removeAllObjects];
    CGFloat shareHeight = 0;
    if ([self.dataSource respondsToSelector:@selector(shareSectionsInTesla:)]) {
        self.shareLayoutView.frame = self.bounds;
        NSArray<FMLayoutBaseSection *> *sections = [self.dataSource shareSectionsInTesla:self];
        [self addSubview:self.shareLayoutView];
        [self.shareLayoutView.layout setSections:sections];
        [self.shareLayoutView.layout handleSections];
        shareHeight = [sections lastObject].sectionHeight + [sections lastObject].sectionOffset;
        self.shareLayoutView.frame = CGRectMake(0, 0, self.bounds.size.width, shareHeight);
        self.suspensionAlwaysHeader = sections.count > 0 ? ([sections lastObject].header.type == FMSupplementaryTypeSuspensionAlways ? [sections lastObject] :nil) : nil;
    }
    
    NSInteger nums = [self.dataSource numberOfScreenInTesla:self];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * nums, 0);
    for (int i = 0; i<nums; i++) {
        FMCollectionLayoutView *collectionView = [[FMCollectionLayoutView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width * i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        collectionView.configuration = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.alwaysBounceVertical = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [self.scrollView addSubview:collectionView];
        [collectionView.layout setFirstSectionOffsetY:shareHeight];
        [collectionView.layout setSections:[self.dataSource tesla:self sectionsInScreenIndex:i]];
        [collectionView reloadData];
        if (self.currentLayoutView == nil) {
            self.currentLayoutView = collectionView;
        }
        [self.layoutViews addObject:collectionView];
    }
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
    
    if ([self.delegate respondsToSelector:@selector(tesla:didScrollEnd:currentLayoutView:)]) {
        [self.delegate tesla:self didScrollEnd:index currentLayoutView:self.currentLayoutView];
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
                
                if (contentOffset.y < 0) {
                    CGRect frame = self.shareLayoutView.frame;
                    frame.origin.y = contentOffset.y;
                    frame.size.height = self.shareLayoutView.contentSize.height - contentOffset.y;
                    self.shareLayoutView.frame = frame;
                    self.shareLayoutView.contentOffset = CGPointMake(0, contentOffset.y);
                }
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
    if (scrollView == self.scrollView) {
        if (!decelerate) {
            [self scrollEnd];
        } else {
            self.userInteractionEnabled = NO;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self scrollEnd];
    }
}

@end
