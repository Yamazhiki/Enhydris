//
// Created by 王斌 on 2019-01-23.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 默认模块采用的构造方式
 */
@protocol ModuleCreatorType <NSObject>
@optional
+ (id)instanceWithParams:(NSDictionary *)params;

@optional
- (id)initWithParams:(NSDictionary *)params;
@end