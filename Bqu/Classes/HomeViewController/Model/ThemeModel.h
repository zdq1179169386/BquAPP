//
//  ThemeModel.h
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeModel : NSObject
@property (nonatomic, copy)NSString *ImageUrl;
@property (nonatomic, copy)NSString *TopicID;
@property (nonatomic, copy)NSString *Description;
@property (nonatomic, copy)NSString *resultCode;
@property (nonatomic, copy)NSString *errors;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, copy)NSString *totalCount;

+ (ThemeModel *)createModelDictionary:(NSDictionary *)dic;
@end
