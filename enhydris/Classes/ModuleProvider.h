//
// Created by 王斌 on 2019-01-08.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleDefine.h"
#import "ModuleResponse.h"
#import "ModuleDefinition.h"

@class ModuleDefinition;

@interface ModuleProvider : NSObject

/**
 * 此方法获取被注册协议的实现
 * @param aProtocol     协议
 * @return 协议的实现    id<aProtocol>
 */
+ (ModuleResponse *)request:(Protocol *)aProtocol;

/**
 * 获得被注册的协议实现
 * @param aProtocol     协议
 * @param params        协议实例构造所需要的参数
 * @return              ModuleResponse 实例
 */
+ (ModuleResponse *)request:(Protocol *)aProtocol params:(NSDictionary *)params;


/**
 *
 * @param aProtocol 协议
 * @param success   回调
 */
+ (void)request:(Protocol *)aProtocol success:(void (^)(id))success;

/**
 * 获取注册协议
 * @param aProtocol     协议
 * @param params        参数
 * @param success       成功回调 （参数为实例）
 * @param failure       失败回调
 */
+ (void)request:(Protocol *)aProtocol params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 获取被注册模块的协议实现
 * @param urlString     URL : module://user?order=1&name=Yamazhiki
 * @return              ModuleResponse
 */
+ (ModuleResponse *)url:(NSString *)urlString;

/**
 * 动态注册模块
 * @param components 组件
 */
+ (void)registerComponents:(NSArray<ModuleDefinition *> *)components;

/**
 * 检测是否生成了对象(弱引用)
 * @param aProtocol 协议对象
 * @return BOOL
 */
+ (BOOL)hasWeakRef:(Protocol *)aProtocol;

@end


#define  weak_obj(type, instance) \
  __weak  id <type> instance = [ModuleProvider request:@protocol(type)].object; \
