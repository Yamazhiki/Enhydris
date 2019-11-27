//
// Created by 王斌 on 2019-01-22.
// Copyright (c) 2019 Yamazhiki. All rights reserved.
//

#import "ModuleConfigCollector.h"
#import "ModuleJsonConfigProcessor.h"

static NSString *ModuleConfigJsonFileName = @"moduleConfigs";

@interface ModuleConfigCollector ()
@property(readonly) id appDelegate;
@end

@implementation ModuleConfigCollector
- (instancetype)initWithAppDelegate:(id)appDelegate {
    self = [super init];
    _appDelegate = appDelegate;
    return self;
}

- (NSArray *)retrieveConfig {
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:[self retrieveConfigFromAppDelegate]];
    [result addObjectsFromArray:[self retrieveConfigFromJson]];
    return result;
}

- (NSArray *)retrieveConfigFromJson {
    NSMutableArray *array = [NSMutableArray array];
    NSBundle *bundle = [NSBundle bundleForClass:[self.appDelegate class]];
    NSString *configPath = [bundle pathForResource:ModuleConfigJsonFileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:configPath];
    if (data) {
        NSError *error;
        NSArray<NSDictionary<NSString *, NSDictionary *> *> *configs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            for (id item in configs) {
                id definition = [ModuleJsonConfigProcessor process:item];
                if (definition)
                    [array addObject:definition];
            }
        }
    }
    return array;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (NSArray *)retrieveConfigFromAppDelegate {
    return @[];
}
#pragma clang diagnostic pop


@end
