//
//  OntimeModel.m
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OntimeModel.h"

@implementation OntimeModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (OntimeModel *)createOntimeModel:(NSDictionary *)dic
{
    OntimeModel *ontime = [[OntimeModel alloc]init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        
        ontime.ImageUrl = dic[@"ImageUrl"];
        ontime.ProductId = dic[@"ProductId"];
        ontime.Storage = dic[@"Storage"];
    }
    //    ontime.errors = dic[@"errors"];
    //    ontime.message = dic[@"message"];
    //    ontime.resultCode = dic[@"resultCode"];
    //    ontime.totalCount = dic[@"totalCount"];
    return ontime;
}
@end
