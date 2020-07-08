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

- (void)setCrossSection:(FMLayoutCrossSection *)crossSection{
    _crossSection = crossSection;
    self.layoutView.layout.direction = crossSection.crossDirection;
    self.layoutView.layout.sections = crossSection.sections;
    self.layoutView.delegate = crossSection;
    if (crossSection.configureCollectionView) {
        crossSection.configureCollectionView(self.layoutView, crossSection);
    }
    [self layoutSubviews];
    [self.layoutView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layoutView.frame = self.contentView.bounds;
}

@end
