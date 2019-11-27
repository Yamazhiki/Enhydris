//
// Created by 王斌 on 2019-01-14.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "ModuleDefinition.h"

@interface ModuleDefinition ()

@property(nonatomic, readwrite) NSArray<ModuleConfig *> *configCollection;

- (instancetype)initWithProtocol:(Protocol *)aProtocol moduleName:(NSString *)moduleName;

@end

@implementation ModuleDefinition


- (instancetype)initWithProtocol:(Protocol *)aProtocol moduleName:(NSString *)moduleName {
    self = [super init];
    if (self) {
        _aProtocol = aProtocol;
        _moduleName = moduleName ? moduleName : NSStringFromProtocol(_aProtocol);
    }
    return self;
}

+ (instancetype)definitionWithProtocol:(Protocol *)aProtocol configuration:(NSArray<ModuleConfig *> *(^)(void))configuration {
    return [self definitionWithProtocol:aProtocol moduleName:nil configuration:configuration];
}

+ (instancetype)definitionWithProtocol:(Protocol *)aProtocol moduleName:(NSString *)moduleName configuration:(NSArray<ModuleConfig *> *(^)(void))configuration {
    ModuleDefinition *definition = [[ModuleDefinition alloc] initWithProtocol:aProtocol moduleName:moduleName];
    if (configuration) {
        definition.configCollection = configuration();
    }
    return definition;
}

- (ModuleConfig *)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.configCollection[idx];
}

- (void)addConfigs:(NSArray<ModuleConfig *> *)configs {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithArray:self.configCollection];
    [tempSet addObjectsFromArray:configs];
    self.configCollection = tempSet.array;
}

- (NSArray<ModuleConfig *> *)configs {
    return self.configCollection;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"Protocol": NSStringFromProtocol(self.aProtocol), @"name": _moduleName, @"configs": self.configCollection}];
}


@end
