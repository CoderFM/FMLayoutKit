//
//  FMFPSLabel.m
//  FMLayoutKit_Example
//
//  Created by 郑桂华 on 2020/7/1.
//  Copyright © 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMFPSLabel.h"

@interface FMFPSLabel ()

@property(nonatomic, strong)CADisplayLink *link;

@property(nonatomic, assign)CFTimeInterval timestamp;
@property(nonatomic, assign)NSInteger count;

@end

@implementation FMFPSLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLink:)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.link = link;
    }
    return self;
}

- (void)updateLink:(CADisplayLink *)link{
    if (self.timestamp == 0) {
        self.timestamp = link.timestamp;
        return;
    }
    
    self.count ++;
    
    // 两帧间隔时间
    NSTimeInterval delta = link.timestamp - self.timestamp;
    // 过滤刷新次数
    if (delta < 1) return;
    // 计算FPS
    self.timestamp = link.timestamp;
    float fps = self.count / delta;
    self.count = 0;
    
    self.text = [NSString stringWithFormat:@"%d FPS", (int)round(fps)];
}

@end
