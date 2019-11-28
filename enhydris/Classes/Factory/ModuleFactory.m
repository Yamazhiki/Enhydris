//
// Created by 王斌 on 2019-01-22.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <objc/runtime.h>
#import <CoreData/CoreData.h>
#import "ModuleFactory.h"
#import "ModuleDefinition.h"
#import "ModuleResponse.h"
#import "AutoDescribe.h"

static NSString *ModuleScheme = @"module";

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define ApplicationClass [UIApplication class]
#elif TARGET_OS_MAC
#define ApplicationClass [NSApplication class]
#endif

@interface ModuleFactory ()
@property(readonly) NSMutableDictionary<NSString *, ModuleDefinition * > *definitions;
@property(readonly) NSMutableDictionary<NSString *, ModuleDefinition * > *definitionWithModuleNames;
@property(readonly) NSMutableArray<AutoDescribe *> *describes;
@property(readonly) NSMutableDictionary<NSString *, NSObject *> *singletonRefs;
@property(readonly) NSMapTable<NSString *, NSObject *> *weakRefs;
@property(nonatomic) NSMutableArray<ModuleDefinition *> *needStartUp;
@end

@implementation ModuleFactory

+ (void)load {
    [self swizzleDelegateSelector];
}

+ (void)swizzleDelegateSelector {
    SEL sel = @selector(setDelegate:);
    Method method = class_getInstanceMethod(ApplicationClass, sel);
    void (*originalImp)(id, SEL, id) = (void (*)(id, SEL, id)) method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^(id instance, id delegate) {
        originalImp(instance, sel, delegate);
        [self.defaultFactory setUp];
    });

    method_setImplementation(method, adjustedImp);
}

+ (instancetype)defaultFactory {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ModuleFactory alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    _definitions = [NSMutableDictionary new];
    _definitionWithModuleNames = [NSMutableDictionary new];
    _singletonRefs = [NSMutableDictionary new];
    _describes = [@[] mutableCopy];
    _weakRefs = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                          valueOptions:NSPointerFunctionsWeakMemory
                                              capacity:0];
    return self;
}

- (void)injectProperties {
    [_describes enumerateObjectsUsingBlock:^(AutoDescribe *obj, NSUInteger idx, BOOL *stop) {
        Method method = class_getInstanceMethod(obj.cls, obj.sel);
        IMP adjustedImp = imp_implementationWithBlock(^id() {
            return [self obtainModuleByProtocol:obj.aProtocol params:nil condition:0].object;
        });
        method_setImplementation(method, adjustedImp);
    }];
}

- (void)combineWithObtainedConfigs:(NSArray<ModuleDefinition *> *)configs {
    [configs enumerateObjectsUsingBlock:^(ModuleDefinition *obj, NSUInteger idx, BOOL *stop) {
        NSString *protocolString = NSStringFromProtocol(obj.aProtocol);
        ModuleDefinition *definition = self.definitions[protocolString];
        if (!definition) {
            self.definitions[protocolString] = obj;
            definition = obj;
        } else {
            [definition addConfigs:obj.configs];
        }
        if (![protocolString isEqualToString:definition.moduleName]) {
            self.definitionWithModuleNames[definition.moduleName] = definition;
        }
    }];
}

- (void)startUpModuleIfNeed:(ModuleDefinition *)definition {
    [definition.configs enumerateObjectsUsingBlock:^(ModuleConfig *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isAutoStartUp) {
            if (!self.needStartUp)
                self.needStartUp = [@[] mutableCopy];
            [self.needStartUp addObject:definition];
        }
    }];
}

- (ModuleResponse *)obtainModuleByProtocol:(Protocol *)aProtocol
                                    params:
                                            (NSDictionary *)params
                                 condition:
                                         (ModuleIndex)condition {
    NSString *key = NSStringFromProtocol(aProtocol);
    ModuleDefinition *definition = _definitions[key];

    if (definition) {
        return [self obtainModule:definition params:params condition:condition];
    } else {
        return [ModuleResponse responseWithError:[NSError errorWithDomain:ModuleErrorDomain
                                                                     code:ModuleErrorNotFound
                                                                 userInfo:@{@"protocol": NSStringFromProtocol(aProtocol)}]];
    }
}

- (ModuleResponse *)obtainModule:(ModuleDefinition *)definition
                          params:
                                  (NSDictionary *)params
                       condition:
                               (ModuleIndex)condition {
    NSString *key = NSStringFromProtocol(definition.aProtocol);
    ModuleConfig *config = definition.configs[condition];
    id instance = nil;
    switch (config.scope) {
        case ModuleScopePrototype: {
            instance = [config create:params];
            break;
        }
        case ModuleScopeSingleton: {
            @synchronized (self.singletonRefs) {
                instance = self.singletonRefs[key];
                if (!instance) {
                    instance = [config create:params];
                    self.singletonRefs[key] = instance;
                }
            }
            break;
        }
        case ModuleScopeWeakSingleton: {
            @synchronized (self.weakRefs) {
                instance = [self.weakRefs objectForKey:key];
                if (!instance) {
                    instance = [config create:params];
                    [self.weakRefs setObject:instance forKey:key];
                }
            }
            break;
        }
        default:
            break;
    }
    return [ModuleResponse responseWithObject:instance];
}

- (ModuleResponse *)obtainModuleByURL:(NSString *)urlString {
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    if (![components.scheme isEqualToString:ModuleScheme]) {
        return [ModuleResponse responseWithErrorCode:ModuleErrorSchemeError];
    }
    ModuleDefinition *definition = self.definitionWithModuleNames[components.host];
    if (!definition) {
        return [ModuleResponse responseWithErrorCode:ModuleErrorNotRegistered];
    }
    __block NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    __block NSUInteger condition = 0;
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
        params[obj.name] = obj.value;
        if ([obj.name isEqualToString:@"moduleIndex"]) {
            condition = (NSUInteger) [obj.value integerValue];
        }
    }];
    return [self obtainModule:definition params:params condition:condition];
}

- (void)registerComponents:(NSArray<ModuleDefinition *> *)components {
    @synchronized (self.definitions) {
        [components enumerateObjectsUsingBlock:^(ModuleDefinition *obj, NSUInteger idx, BOOL *stop) {
            self.definitions[NSStringFromProtocol(obj.aProtocol)] = obj;
            [self startUpModuleIfNeed:obj];
        }];
    }
}

- (BOOL)hasCreateWeakRef:(Protocol *)aProtocol {
    return [self.weakRefs objectForKey:NSStringFromProtocol(aProtocol)] != nil;
}

- (void)setUp {
    NSArray *temp = [self.needStartUp sortedArrayUsingComparator:^NSComparisonResult(ModuleDefinition *obj1, ModuleDefinition *obj2) {
        if (obj1.configs.firstObject.priority >= obj2.configs.firstObject.priority) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    [temp enumerateObjectsUsingBlock:^(ModuleDefinition *obj, NSUInteger idx, BOOL *stop) {
        [self obtainModule:obj params:nil condition:0];
    }];
}


@end
