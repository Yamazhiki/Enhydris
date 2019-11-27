//
// Created by 王斌 on 2019-01-14.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ModuleConfig.h"
#import "ModuleDefine.h"

@class ModuleConfig;

/**
 * 模块定义类 （同是也是扩展点）
 * 如果 协议 id<Type> 则 aProtocol 为 Protocol<A>; cls 必须具备实现<A> 同时具有Creator协议的方法
 *
 */
@interface ModuleDefinition : NSObject
/**
 * 被导出模块的协议
 */
@property(readonly) Protocol *aProtocol;

@property(readonly) NSString *moduleName;

@property(readonly) NSArray<ModuleConfig *> *configs;

/**
 * 实例
 * @param   aProtocol         协议
 * @param   configuration     配置
 * @return  ModuleDefinition
 */
+ (instancetype)definitionWithProtocol:(Protocol *)aProtocol
                         configuration:(NSArray<ModuleConfig *> *(^)(void))configuration;

/**
 * 实例
 * @param aProtocol           协议
 * @param moduleName          模块别名
 * @param configuration       配置
 * @return ModuleDefinition
 */
+ (instancetype)definitionWithProtocol:(Protocol *)aProtocol
                            moduleName:(NSString *)moduleName
                         configuration:(NSArray<ModuleConfig *> *(^)(void))configuration;

- (ModuleConfig *)objectAtIndexedSubscript:(NSUInteger)idx;


/**
 * 覆盖配置
 * @param configs 目标配置集合
 */

- (void)addConfigs:(NSArray<ModuleConfig *> *)configs;


@end
