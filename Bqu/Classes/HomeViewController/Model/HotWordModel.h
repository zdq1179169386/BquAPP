//
//  HotWordModel.h
//  Bqu
//
//  Created by WONG on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotWordModel : NSObject
@property (nonatomic ,strong)NSString *HotWord;

+(HotWordModel *)createHotModel:(NSDictionary *)dic;
@end
