//
// Created by 王斌 on 2019-01-08.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModuleDefinition;

@protocol ModuleExportType <NSObject>
+ (NSArray<ModuleDefinition *> *)services;
@end