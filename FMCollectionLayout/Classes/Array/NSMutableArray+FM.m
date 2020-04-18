//
//  NSMutableArray+FM.m
//  TestDemo
//
//  Created by 周发明 on 17/7/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "NSMutableArray+FM.h"
#import <objc/runtime.h>

@implementation NSMutableArray (FM)

- (void)convertSafety{
    if (![NSStringFromClass(self.class) isEqualToString:NSStringFromClass([FMSafetyMutableArray class])]) {
        NSMutableArray *arr = [self mutableCopy];
        [self removeAllObjects];
        object_setClass(self, [FMSafetyMutableArray class]);
        FMSafetyMutableArray *arrM = (FMSafetyMutableArray *)self;
        [arrM addObjectsFromArray:arr];
    }
}

- (void)listenDidChange:(FMSafetyMutableArrayChangeBlock)changeBlock{
    [self convertSafety];
    FMSafetyMutableArray *arrM = (FMSafetyMutableArray *)self;
    arrM.changeBlock = changeBlock;
}

- (void)addTargetView:(id)target{
    if ([target respondsToSelector:@selector(reloadData)]){
        [self convertSafety];
        if ([self respondsToSelector:@selector(addTarget:)]) {
            [self performSelector:@selector(addTarget:) withObject:target];
        }
    }
}

@end
