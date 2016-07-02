//
//  DTSingleton.m
//  剧能玩2.1
//
//  Created by dzb on 15/11/23.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import "DTSingleton.h"
@interface DTSingleton  ()
{
   
    __weak                  id<DTSingletonDelegate>_delegate;
}

@end

@implementation DTSingleton

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
   static DTSingleton *_singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:_singleton selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_singleton selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_singleton selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_singleton selector:@selector(applicationDidActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
    return _singleton;
}

+ (void)addDelegate:(id<DTSingletonDelegate>)delegate
{
    DTSingleton *singleton      = [DTSingleton shareSingleton];
    singleton->_delegate        = delegate;
}
+ (instancetype)shareSingleton
{
    return [[super alloc] init];
}

#pragma mark - 监听程序声明周期的通知
/**
 *  程序即将失去响应
 */
- (void)applicationWillResignActive:(NSNotification*)noti
{
    UIApplication *application = (UIApplication*)noti.object;
    if ([_delegate respondsToSelector:@selector(applicationWillResignActive:)]) {
        [_delegate applicationWillResignActive:application];
    }
}
/**
 *  应用被强退
 */
- (void)applicationWillTerminate:(NSNotification *)noti
{
    UIApplication *application = (UIApplication*)noti.object;
    if ([_delegate respondsToSelector:@selector(applicationWillTerminate:)]) {
        [_delegate applicationWillTerminate:application];
    }
}
/**
 *  程序进入后台
 */
- (void)applicationDidEnterBackground:(NSNotification *)noti
{
    UIApplication *application = (UIApplication*)noti.object;
    if ([_delegate respondsToSelector:@selector(applicationDidEnterBackground:)]) {
        [_delegate applicationDidEnterBackground:application];
    }
}
/**
 *  程序开始活跃
 */
- (void)applicationDidActive:(NSNotification *)noti {
    UIApplication *application = (UIApplication*)noti.object;
    if ([_delegate respondsToSelector:@selector(applicationDidActive:)]) {
        [_delegate applicationDidActive:application];
    }
    
}



@end
