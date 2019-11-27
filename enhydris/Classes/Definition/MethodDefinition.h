//
// Created by 王斌 on 2019-01-15.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MethodDefinitionType) {
    /**
     * 实例方法
     */
            MethodDefinitionTypeInstanceMethod,
    /**
     * 类方法
     */
            MethodDefinitionTypeClassMethod
};

@interface MethodDefinition : NSObject

@property(readonly) MethodDefinitionType type;
@property(readonly) SEL method;

+ (instancetype)methodWithClass:(SEL)classMethod;

+ (instancetype)methodWithInstance:(SEL)instanceMethod;

/**
 * 根据param构造实例
 * @param methodString 方法字符串（ex: -init 代表实例方法，+shared 代表类方法）
 * @return MethodDefinition
 */
+ (instancetype)methodWithString:(NSString *)methodString;
@end