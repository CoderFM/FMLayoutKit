//
//  FMLayoutCrossCell.m
//  FMLayoutKit
//
//  Created by 周发明 on 2020/6/16.
//

#import "FMLayoutCrossCell.h"
#import "FMLayoutView.h"
#import "FMLayoutCrossSection.h"

@interface FMLayoutCrossCell()<UICollectionViewDelegate>
@property(nonatomic, weak)FMLayoutView *layoutView;
@end

@implementation FMLayoutCrossCell

- (void)dealloc{
    FMLayoutLog(@"FMHorizontalCell dealloc");
}

- (FMLayoutView *)layoutView{
    if (_layoutView == nil) {
        FMLayoutView *view = [[FMLayoutView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        _layoutView = view;
    }
    return _layoutView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.layoutView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.contentView addConstraints:@[left,right,top,bottom]];
    }
    return self;
}

- (void)setCrossSection:(FMLayoutCrossSection *)crossSection{
    _crossSection = crossSection;
    self.layoutView.layout.direction = crossSection.crossDirection;
    self.layoutView.layout.sections = crossSection.sections;
    self.layoutView.delegate = crossSection;
    [self.layoutView reloadData];
    if (crossSection.configureCollectionView) {
        crossSection.configureCollectionView(self.layoutView, crossSection);
    }
}

@end
