//
//  CMLocationModel.h
//  CMWeibo
//
//  Created by jiachenmu on 16/7/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  定位后，通过经纬度，调用百度地图Api 获取周边地址信息

#import <Foundation/Foundation.h>

//MARK: 地理经纬度信信息
@interface Location : NSObject

@property (assign, nonatomic) double lng;
@property (assign, nonatomic) double lat;

@end



//MARK:  周边信息
@interface PoistionNearByModel : NSObject

@property (strong, nonatomic) NSString *uid;

/// 距离
@property (strong, nonatomic) NSString *distance;

/// 经纬度信息
@property (strong, nonatomic) Location *point;

@property (strong, nonatomic) NSString *addr;

@property (strong, nonatomic) NSString *poiType;

@property (strong, nonatomic) NSString *tag;

@property (strong, nonatomic) NSString *direction;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *tel;

+ (instancetype)nearbyInfolWithObject:(id)obj;

@end

@interface CMLocationModel : NSObject

@property (strong, nonatomic) Location* location;

@property (strong, nonatomic) NSArray <PoistionNearByModel *> *pois;

@property (assign, nonatomic) NSString *sematic_description;

//商圈
@property (strong, nonatomic) NSString *business;
//地址详情信息
@property (strong, nonatomic) NSString *formatted_address;

+ (instancetype)initWithJSONString:(NSString *)jsonString;

@end
