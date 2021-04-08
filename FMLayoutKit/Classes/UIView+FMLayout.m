//
//  UIView+FMLayout.m
//  FMLayoutKit
//
//  Created by 郑桂华 on 2021/3/27.
//

#import "UIView+FMLayout.h"

@implementation UIView (FMLayout)

- (UIView *)snapshotView{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UIView *sourceView = [[UIView alloc] initWithFrame:self.frame];
    sourceView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    sourceView.layer.shadowOffset = CGSizeMake(0, 0);
    sourceView.layer.shadowOpacity = 0.7;
    [sourceView addSubview:imageView];
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sourceView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sourceView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sourceView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sourceView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [sourceView addConstraints:@[left,right,top,bottom]];
    return sourceView;
}

@end
