//
// Created by 王斌 on 2019-01-15.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodDefinition.h"


@implementation MethodDefinition

- (instancetype)initWithType:(MethodDefinitionType)type method:(SEL)method {
    self = [super init];
    _type = type;
    _method = method;
    return self;
}

+ (instancetype)methodWithClass:(SEL)classMethod {
    return [self methodWithString:[NSString stringWithFormat:@"+%@", NSStringFromSelector(classMethod)]];
}

+ (instancetype)methodWithInstance:(SEL)instanceMethod {
    return [self methodWithString:[NSString stringWithFormat:@"-%@", NSStringFromSelector(instanceMethod)]];
}

+ (instancetype)methodWithString:(NSString *)methodString {
    MethodDefinitionType type = MethodDefinitionTypeClassMethod;
    if ([methodString hasPrefix:@"-"]) {
        type = MethodDefinitionTypeInstanceMethod;
    }
    SEL method = NSSelectorFromString([methodString substringWithRange:NSMakeRange(1, methodString.length - 1)]);
    return [[MethodDefinition alloc] initWithType:type method:method];
}


@end