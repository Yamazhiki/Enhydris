//
// Created by 王斌 on 2019-03-04.
// Copyright (c) 2019 AsiaInnovations. All rights reserved.
//

#import <objc/runtime.h>
#import "PropertyProcessor.h"
#import "AutoDescribe.h"


@implementation PropertyProcessor {

}
+ (NSArray<NSValue *> *)describesForClass:(Class)clz {
    NSMutableArray *rlt = [@[] mutableCopy];
    unsigned int count;
    objc_property_t *props = class_copyPropertyList(clz, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char *type = property_getAttributes(property);
        NSString *typeString = [NSString stringWithUTF8String:type];
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = attributes[0];
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^T@\"AutoInject<[A-Z]*+>\"$"
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:nil];
        NSArray *match = [regularExpression matchesInString:typeAttribute
                                                    options:NSMatchingReportCompletion
                                                      range:NSMakeRange(0, [typeAttribute length])];
        if (match.firstObject) {
            __block NSString *getProperty = nil;
            [attributes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj hasPrefix:@"G"]) {
                    getProperty = [obj substringWithRange:NSMakeRange(1, obj.length - 1)];
                    *stop = YES;
                }
                if ([obj hasPrefix:@"V_"]) {
                    NSString *propertyName = [obj substringWithRange:NSMakeRange(2, obj.length - 2)];
                    getProperty = propertyName;
                }
            }];

            NSUInteger start = [typeAttribute rangeOfString:@"<"].location;
            NSUInteger end = [typeAttribute rangeOfString:@">"].location;
            NSString *str = [typeAttribute substringWithRange:NSMakeRange(start + 1, end - start - 1)];
            [rlt addObject:[AutoDescribe describeWithCls:clz
                                               aProtocol:NSProtocolFromString(str)
                                                     sel:NSSelectorFromString(getProperty)]];
        }
    }
    free(props);
    return rlt;
}
@end