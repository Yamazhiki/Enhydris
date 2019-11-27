//
// Created by 王斌 on 2019-01-17.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleDefinition.h"

@interface ModuleDefinition (Generator)
/**
 * 根据当前ModuleDefinition覆盖现有ModuleDefinition （属性覆盖）
 * @param other 目标描述
 * @return ModuleDefinition
 */
- (instancetype)replace:(ModuleDefinition *)other;
@end