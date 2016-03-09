//
//  SlideViewModel.h
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideViewModel : NSObject
@property (nonatomic,copy)NSString *ImageUrl;
@property (nonatomic,copy)NSString *JumpUrl;

+(SlideViewModel *)createModelWithDictionary:(NSDictionary *)dic;
@end
