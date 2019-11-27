//
// Created by 王斌 on 2019-01-17.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleConfig.h"
#import "ModuleCreatorType.h"

@interface ModuleConfig ()
@end


@implementation ModuleConfig
- (instancetype)initWithCls:(Class)cls {
    return [self initWithCls:cls scope:ModuleScopePrototype isAutoStartUp:NO priority:NSUIntegerMax];
}

- (instancetype)initWithCls:(Class)cls scope:(ModuleScope)scope {
    return [self initWithCls:cls scope:scope isAutoStartUp:ModuleScopeSingleton == scope priority:NSUIntegerMax];
}

- (instancetype)initWithCls:(Class)cls scope:(ModuleScope)scope isAutoStartUp:(BOOL)isAutoStartUp priority:(NSUInteger)priority {
    self = [super init];
    if (self) {
        _cls = cls;
        _scope = scope;
        _isAutoStartUp = isAutoStartUp;
        _priority = priority;
    }

    return self;
}

- (instancetype)initWithCls:(Class)cls isAutoStartUp:(BOOL)isAutoStartUp {
    return [self initWithCls:cls scope:ModuleScopeSingleton isAutoStartUp:YES priority:NSUIntegerMax];
}

- (instancetype)initWithCls:(Class)cls isAutoStartUp:(BOOL)isAutoStartUp priority:(NSUInteger)priority {
    return [self initWithCls:cls scope:ModuleScopeSingleton isAutoStartUp:YES priority:priority];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (id)create:(NSDictionary *)params {
    id <ModuleCreatorType> p = (id <ModuleCreatorType>) self.cls;
    if ([self.cls respondsToSelector:@selector(instanceWithParams:)]) {
        return [p instanceWithParams:params];
    }

    p = (id <ModuleCreatorType>) [self.cls alloc];
    if ([p respondsToSelector:@selector(initWithParams:)]) {
        return [p initWithParams:params];
    }

    return [[self.cls alloc] init];
}

#pragma clang diagnostic pop

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        ModuleConfig *target = object;
        return [NSStringFromClass(target.cls) isEqualToString:NSStringFromClass(self.cls)];
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"scope: %d, class: %@", (int) self.scope, NSStringFromClass(self.cls)];
}


@end