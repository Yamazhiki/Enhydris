//
// Created by 王斌 on 2019-01-08.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleProvider.h"
#import "ModuleFactory.h"
#import <objc/runtime.h>

static NSMutableDictionary<NSString *, ModuleDefinition * > *instancePlaceholder;
static NSMutableDictionary<NSString *, NSObject *> *container;
static NSMapTable<NSString *, NSObject *> *weakRef;


@implementation ModuleProvider {

}

+ (void)setUp {
    [ModuleFactory.defaultFactory setUp];

}

+ (id)request:(Protocol *)aProtocol {
    return [self request:aProtocol params:nil];
}

+ (id)request:(Protocol *)aProtocol params:(NSDictionary *)params {
    return [self request:aProtocol params:params condition:0];
}

+ (ModuleResponse *)request:(Protocol *)aProtocol params:(NSDictionary *)params condition:(ModuleIndex)condition {
    return [ModuleFactory.defaultFactory obtainModuleByProtocol:aProtocol params:params condition:condition];
}

+ (void)request:(Protocol *)aProtocol success:(void (^)(id))success {
    [self request:aProtocol params:nil success:success failure:nil];
}

+ (void)request:(Protocol *)aProtocol params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    ModuleResponse *response = [self request:aProtocol params:params condition:0];
    if (response.error && failure) {
        failure(response.error);
    } else {
        if (success)
            success(response.object);
    }
}

+ (ModuleResponse *)url:(NSString *)urlString {
    return [ModuleFactory.defaultFactory obtainModuleByURL:urlString];
}

+ (void)registerComponents:(NSArray<ModuleDefinition *> *)components {
    [ModuleFactory.defaultFactory registerComponents:components];
}

+ (BOOL)hasWeakRef:(Protocol *)aProtocol {
    return [ModuleFactory.defaultFactory hasCreateWeakRef:aProtocol];
}


@end
