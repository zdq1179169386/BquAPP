//
//  HotWordModel.m
//  Bqu
//
//  Created by WONG on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HotWordModel.h"

@implementation HotWordModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(HotWordModel *)createHotModel:(NSDictionary *)dic {
    HotWordModel *hotModel = [[HotWordModel alloc]init];
    hotModel.HotWord = dic[@"data"];
    return hotModel;
}
@end
