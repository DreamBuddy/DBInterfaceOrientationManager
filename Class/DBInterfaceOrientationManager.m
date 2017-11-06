//
//  DBInterfaceOrientationManager.m
//  DBInterfaceOrientationManagerDemo
//
//  Created by 徐梦童 on 2017/11/7.
//  Copyright © 2017年 徐梦童. All rights reserved.
//

#import "DBInterfaceOrientationManager.h"
#import <objc/runtime.h>

/**
 *  Instance Method Swizzling
 *
 *  @param originalSelector 原方法
 *  @param swizzledSelector 即将交换的方法
 */
static inline void DBExchangedInstanceMethod(SEL originalSelector, SEL swizzledSelector, Class aClass) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@interface DBInterfaceOrientationManager ()

@property (assign ,nonatomic) BOOL allowRotation;

@end

@implementation DBInterfaceOrientationManager

+ (void)allowRotation:(BOOL)allow {
    [self sharedInstance].allowRotation = allow;
}

/**
 Source: http://www.cocoachina.com/ios/20160722/17148.html
 Source: http://www.jianshu.com/p/7cb20980053d
 */
+ (void)forceInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - SharedInstance
+ (DBInterfaceOrientationManager *)sharedInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = DBInterfaceOrientationManager.new;
        }
    });
    return instance;
}

@end

//*************** AppDelegate *********************

@implementation UIResponder (DBInterfaceOrientationManager)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBExchangedInstanceMethod(@selector(application:supportedInterfaceOrientationsForWindow:), @selector(icq_application:supportedInterfaceOrientationsForWindow:), self.class);
    });
}

- (UIInterfaceOrientationMask)icq_application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if ([DBInterfaceOrientationManager sharedInstance].allowRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end

@implementation UITabBarController (iCQInterfaceOrientation)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBExchangedInstanceMethod(@selector(supportedInterfaceOrientations), @selector(icq_supportedInterfaceOrientations), self.class);
        DBExchangedInstanceMethod(@selector(shouldAutorotate), @selector(icq_shouldAutorotate), self.class);
    });
}

#pragma mark - 支持旋转屏幕
- (UIInterfaceOrientationMask)icq_supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (BOOL)icq_shouldAutorotate{
    return [DBInterfaceOrientationManager sharedInstance].allowRotation;
}

@end

@implementation UINavigationController (iCQInterfaceOrientation)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBExchangedInstanceMethod(@selector(supportedInterfaceOrientations), @selector(icq_supportedInterfaceOrientations), self.class);
        DBExchangedInstanceMethod(@selector(shouldAutorotate), @selector(icq_shouldAutorotate), self.class);
    });
}

#pragma mark - 支持旋转屏幕
- (UIInterfaceOrientationMask)icq_supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)icq_shouldAutorotate{
    return [DBInterfaceOrientationManager sharedInstance].allowRotation;
}

@end
