//
//  BquSearchConditionModel.m
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "BquSearchConditionModel.h"

@implementation BquSearchConditionModel


-(instancetype)init
{
    if (self = [super init]) {
        _cid = @"0";
        _bid = @"0";
        _shopid = @"0";
        _countryid = @"0";
    }
    return self;
}
-(void)setValueFromDic:(NSDictionary*)dic
{
    id key = dic[@"cid"];
    if (key) {
        _cid = dic[@"cid"];
        _cidName =dic[@"cidName"];
    }
    key = dic[@"bid"];
    if (key) {
        _bid = dic[@"bid"];
        _bidName =dic[@"bidName"];
    }
    key = dic[@"shopid"];
    if (key) {
        _shopid = dic[@"shopid"];
        _shopidName =dic[@"shopidName"];
    }
    key = dic[@"countryid"];
    if (key) {
        _countryid = dic[@"countryid"];
        _countryidName =dic[@"countryidName"];
    }
}


-(void)clearAllData
{
    _cid = @"0";
    _bid = @"0";
    _shopid = @"0";
    _countryid = @"0";
    
}

-(void)cleardata:(NSString*)ID
{
    [self setValue:@"0" forKey:ID];
}
@end
