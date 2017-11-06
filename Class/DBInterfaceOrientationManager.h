//
//  DBInterfaceOrientationManager.h
//  DBInterfaceOrientationManagerDemo
//
//  Created by 徐梦童 on 2017/11/7.
//  Copyright © 2017年 徐梦童. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBInterfaceOrientationManager : NSObject

/**
 设置是否允许转屏

 @param allow 布尔值
 */
+ (void)allowRotation:(BOOL)allow;

/**
 强制旋转屏幕
 
 @param orientation 方向
 */
+ (void)forceInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
