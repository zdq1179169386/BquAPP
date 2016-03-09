//
//  TopIcModuleModel.m
//  Bqu
//
//  Created by WONG on 15/10/24.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "TopIcModuleModel.h"
//#import "SearchListCollectionVC.h"
@implementation TopIcModuleModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(TopIcModuleModel *)createModelWithDic:(NSDictionary *)dic {

    TopIcModuleModel *model = [[TopIcModuleModel alloc]init];
    model.ModuleCount = dic[@"ModuleCount"];
    model.ModuleName = dic[@"ModuleName"];
    model.arrays = [NSMutableArray array];
    model.ModuleProduct = [[NSMutableArray alloc]init];
    model.ModuleProduct = dic[@"ModuleProduct"];
    for (NSDictionary *dict in model.ModuleProduct) {

        TopicDetailModel *detailmodel = [TopicDetailModel createDetailModelWithDic:dict];
        [model.arrays addObject:detailmodel];
    }    
    model.times = model.arrays.count;
    
    return model;
}

@end
