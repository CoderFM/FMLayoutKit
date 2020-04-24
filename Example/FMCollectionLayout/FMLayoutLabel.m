//
//  FMLayoutLabel.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/23.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMLayoutLabel.h"

@interface FMLayoutLabel ()

@property(nonatomic, assign)BOOL isLayoutSubviews;
@property(nonatomic, assign)BOOL isAttributeText;
@end

@implementation FMLayoutLabel

- (void)setText:(NSString *)text{
    [super setText:text];
    self.isAttributeText = NO;
    if (self.isLayoutSubviews) {
        [self updateFillSize];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    self.isAttributeText = YES;
    if (self.isLayoutSubviews) {
        [self updateFillSize];
    }
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    if (self.isLayoutSubviews) {
        [self updateFillSize];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.isLayoutSubviews = YES;
    [self updateFillSize];
}

- (void)updateFillSize{
    CGSize size = CGSizeZero;
    if (self.isAttributeText && self.attributedText != nil) {
        CGFloat height = [self.attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, height)];
    }
    if (!self.isAttributeText && self.text != nil) {
        CGFloat height = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size.height;
        size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, height)];
    }
    NSLog(@"updateFillSize %@", [NSValue valueWithCGSize:size]);
}

@end
