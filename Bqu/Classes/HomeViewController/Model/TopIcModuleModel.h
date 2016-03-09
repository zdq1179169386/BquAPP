//
//  TopIcModuleModel.h
//  Bqu
//
//  Created by WONG on 15/10/24.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicDetailModel.h"
@interface TopIcModuleModel : NSObject

@property (nonatomic,copy) NSString * ModuleName ;
@property (nonatomic,strong) NSMutableArray * ModuleProduct;
@property (nonatomic,strong)NSString *ModuleCount;
@property (nonatomic,strong)NSMutableArray *arrays;
@property (nonatomic,assign)NSUInteger times;



+(TopIcModuleModel *)createModelWithDic:(NSDictionary *)dic ;

@end
