//
//  FMSaveMutableArray.h
//  TestDemo
//
//  Created by 周发明 on 17/7/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMSafetyMutableArrayChangeType){
    FMSafetyMutableArrayChangeAddType,
    FMSafetyMutableArrayChangeDeleteType,
    FMSafetyMutableArrayChangeReplaceType,
    FMSafetyMutableArrayChangeOtherType
};

typedef void(^FMSafetyMutableArrayChangeBlock)(NSIndexSet *, FMSafetyMutableArrayChangeType);

@interface FMSafetyMutableArray : NSMutableArray

@property(nonatomic, copy)FMSafetyMutableArrayChangeBlock changeBlock;
@property(nonatomic, assign)BOOL isSync;
- (void)addTarget:(id)target;

@end
