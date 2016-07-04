//
//  WeiboModel.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "WeiboModel.h"
#import "WeiboAttributerString.h"

@implementation WeiboModel

+ (void)setup {
    [WeiboModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"pic_urls" : @"PicModel"
                 };
    }];
}

+ (instancetype)modelWithJSONString:(NSString *)jsonString {
    
    //配置
//    [WeiboModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{
//                 @"" : @"",
//                 
//                 
//                 
//                 };
//    }];
    
    [WeiboModel setup];
    
    WeiboModel *model = [[WeiboModel alloc] init];
    model.cellFrames = [CMWeiboCellFrames cellFramesWithWeiboModel:model];
    if (model.retweeted_status) {
        model.retweeted_status = [RetweetedModel initWithobject:model.retweeted_status];
    }
    return model;
}

@end

@implementation RetweetedModel

+ (instancetype)initWithobject:(id)obj {
    RetweetedModel *retModel = [RetweetedModel mj_objectWithKeyValues:obj];
    
    return retModel;
}

@end

@implementation PicModel

+ (instancetype)picModelWithObject:(id)obj {
    PicModel *model = [[PicModel alloc] init];
    model = [PicModel mj_objectWithKeyValues:[obj mj_keyValues]];
    
    [model setupLargeImageURl];
    return model;
}

- (void)setupLargeImageURl {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.thumbnail_pic];
    NSRange range = [str rangeOfString:@"thumbnail"];
    
    [str replaceCharactersInRange:range withString:@"large"];
    
    self.large_pic = str;
}

@end

@implementation DraftsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wbContent = @"";
        self.isComment = false;
    }
    return self;
}

@end


