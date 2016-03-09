//
//  ThemeModel.m
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
+ (ThemeModel *)createModelDictionary:(NSDictionary *)dic {
    ThemeModel *theme = [[ThemeModel alloc]init];
    theme.ImageUrl = dic[@"ImageUrl"];
    theme.TopicID = dic[@"Id"];
    theme.Description = dic[@"Description"];
    
    return theme;
}
@end
