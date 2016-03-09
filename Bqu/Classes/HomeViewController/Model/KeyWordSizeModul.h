//
//  KeyWordSizeModul.h
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyWordSizeModul : NSObject
@property (nonatomic,copy)NSString *keyWord;
@property (nonatomic,copy,readonly)NSString *lenth;

-(void)setFont:(UIFont*)font;
-(void)setSize:(CGSize)size;


+(void)saveHistorySearch:(NSString *)historySearch;
+(NSMutableArray*)getHistorySearch;
+(void)clearHistorySearch;
@end
