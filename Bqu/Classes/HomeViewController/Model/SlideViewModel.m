//
//  SlideViewModel.m
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SlideViewModel.h"

@implementation SlideViewModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(SlideViewModel *)createModelWithDictionary:(NSDictionary *)dic {
    SlideViewModel *slide = [[SlideViewModel alloc]init];
    slide.ImageUrl = dic[@"ImageUrl"];
    slide.JumpUrl = dic[@"Url"];
    return slide;
}
@end
