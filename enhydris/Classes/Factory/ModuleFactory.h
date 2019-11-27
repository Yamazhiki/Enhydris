//
// Created by 王斌 on 2019-01-22.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleDefine.h"

@class ModuleDefinition;
@class ModuleResponse;
@class ModuleConfig;

/**
 * Module 注册工厂
 */
@interface ModuleFactory : NSObject
/**
 * 默认工厂
 * @return ModuleFactory
 */
+ (instancetype)defaultFactory;

/**
 * 重组现有的ModuleDefinition
 * @param configs 获取到的配置
 */
- (void)combineWithObtainedConfigs:(NSArray<ModuleDefinition *> *)configs;

/**
 * 获取模块实现
 * @param aProtocol     实现协议的模块
 * @param params        参数
 * @param condition     模块索引
 * @return ModuleResponse
 */
- (ModuleResponse *)obtainModuleByProtocol:(Protocol *)aProtocol params:(NSDictionary *)params condition:(ModuleIndex)condition;

/**
 * 获取模块实例
 * @param urlString     模块URL
 * @return ModuleResponse
 */
- (ModuleResponse *)obtainModuleByURL:(NSString *)urlString;

/**
 * 注册组件
 * @param components 组件
 */
- (void)registerComponents:(NSArray<ModuleDefinition *> *)components;

/**
 * 是否存在弱引用
 * @param aProtocol
 * @return BOOL
 */
- (BOOL)hasCreateWeakRef:(Protocol *)aProtocol;

- (void)setUp;
@end