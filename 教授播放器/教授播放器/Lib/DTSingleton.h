//
//  DTSingleton.h
//  剧能玩2.1
//
//  Created by dzb on 15/11/23.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol DTSingletonDelegate <NSObject>

@optional
/**
 *  程序即将失去响应
 */
- (void)applicationWillResignActive:(UIApplication *)application;
/**
 *  应用被强退
 */
- (void)applicationWillTerminate:(UIApplication *)application;

/**
 *  程序进入后台
 */
- (void)applicationDidEnterBackground:(UIApplication *)application;
/**
 *  程序开始活跃
 */
- (void)applicationDidActive:(UIApplication *)application;

@end

@interface DTSingleton : NSObject

+ (instancetype)shareSingleton;

/** < 设置代理对象 > */
+ (void)addDelegate:(id<DTSingletonDelegate>)delegate;


NS_ASSUME_NONNULL_END


@end
