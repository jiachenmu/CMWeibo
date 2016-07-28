//
//  CMLocationModel.m
//  CMWeibo
//
//  Created by jiachenmu on 16/7/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMLocationModel.h"

@implementation CMLocationModel

+ (void)setup {
    [CMLocationModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"pois" : @"PoistionNearByModel"};
    }];
    
 
}

+ (instancetype)initWithJSONString:(NSString *)jsonString {
    [CMLocationModel setup];
    NSDictionary *dict = [jsonString mj_JSONObject];
    
    CMLocationModel *locationModel = [[CMLocationModel alloc] init];
    
    locationModel = [CMLocationModel mj_objectWithKeyValues:dict[@"result"]];
    
    return locationModel;
}

@end


@implementation PoistionNearByModel

+ (instancetype)nearbyInfolWithObject:(id)obj {
    PoistionNearByModel *model = [[PoistionNearByModel alloc] init];
    model = [PoistionNearByModel mj_objectWithKeyValues:[obj mj_keyValues]];
    
    return model;
}

@end