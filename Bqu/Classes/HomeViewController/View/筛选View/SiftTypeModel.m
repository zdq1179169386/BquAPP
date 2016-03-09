//
//  SiftTypeModel.m
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SiftTypeModel.h"

@interface SiftTypeModel()


@end

@implementation SiftTypeModel


+(instancetype)siftTypeModel:(NSDictionary*)dic type:(NSUInteger)type
{
    SiftTypeModel *model = [[SiftTypeModel alloc] init];
    
    NSNumber *num = dic[@"Id"];
    if (num) {
        if (type == 0) {
            model.shopId = [NSString stringWithFormat:@"%@",num];
            model.name = dic[@"HouseName"];
        }
        else if(type == 1)
        {
            model.countryId = [NSString stringWithFormat:@"%@",num];
            model.name = dic[@"Name"];
        }
        
    }
    return model;
}

+(NSArray*)siftTypeModelFromArray:(NSArray*)array type:(NSUInteger)type
{
    NSMutableArray * temp = [NSMutableArray new];

    for ( int i = 0  ; i < array.count ; i++) {
        NSDictionary * dic = array[i];
        SiftTypeModel * model = [SiftTypeModel siftTypeModel:dic type:type];
        [temp addObject:model];
    }
    return (NSArray*)temp;
}
@end
