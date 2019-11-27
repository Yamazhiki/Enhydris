//
// Created by 王斌 on 2019-01-22.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleJsonConfigProcessor.h"
#import "ModuleConfig.h"
#import "ModuleDefinition.h"


@implementation ModuleJsonConfigProcessor

+ (ModuleDefinition *)process:(NSDictionary<NSString *, id> *)resource {
    if (resource) {
        NSString *type = resource[@"type"];
        Protocol *aProtocol = NSProtocolFromString(type);
        if (aProtocol) {
            NSString *name = resource[@"name"];
            NSArray *children = resource[@"configs"];
            __block NSMutableArray *configs = [NSMutableArray array];
            [children enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                Class cls = NSClassFromString(obj[@"target"]);
                if (cls) {
                    NSNumber *number = obj[@"scope"];
                    [configs addObject:[[ModuleConfig alloc] initWithCls:cls
                                                                   scope:number ? (ModuleScope) number.integerValue : ModuleScopePrototype]];
                }
            }];
            return [ModuleDefinition definitionWithProtocol:aProtocol
                                                 moduleName:name
                                              configuration:^NSArray<ModuleConfig *> * {
                                                  return configs;
                                              }];
        }

    }
    return nil;
}

@end