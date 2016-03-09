//
//  KeyWordSizeModul.m
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "KeyWordSizeModul.h"

@interface KeyWordSizeModul ()
{
    UIFont *_font;
    CGSize _size ;
    
}

@end

@implementation KeyWordSizeModul
-(instancetype)init
{
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:14];
        _size = CGSizeMake(320, 23);
    }
    return self;
}

-(void)setKeyWord:(NSString *)keyWord
{
    _keyWord = keyWord;
    CGSize size = [_keyWord sizeWithFont:_font maxW:_size.width];
    _lenth = [NSString stringWithFormat:@"%f",size.width];
}

-(void)setFont:(UIFont*)font
{
    _font = font;
}
-(void)setSize:(CGSize)size
{
    _size = size;
}


+(void)saveHistorySearch:(NSString *)historySearch
{
    if ([historySearch isEqualToString:@""])
    {
        return;
    }
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (userDef) {
        NSArray *historySearchArray = [userDef objectForKey:@"historySearch"];
        if(historySearchArray == nil)
        {
            historySearchArray = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:historySearchArray];
        [temp removeObject:historySearch];
      //[temp addObject:historySearch];
        [temp insertObject:historySearch atIndex:0];
        
        //只记录10条搜索
        if (temp.count > 10) {
            [temp removeLastObject];
        }
        [userDef setObject:temp forKey:@"historySearch"];
    }

    
}


+(NSArray*)getHistorySearch
{
    NSArray * historySearchArray ;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (userDef) {
        historySearchArray = [userDef objectForKey:@"historySearch"];
        if (historySearchArray == nil) {
            historySearchArray = [[NSMutableArray alloc] init];
        }
    }
    
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:historySearchArray.count];
    for (int  i = 0 ; i < historySearchArray.count ; i++)
    {
        KeyWordSizeModul * key = [[KeyWordSizeModul alloc] init];
        key.keyWord = historySearchArray[i];
        [temp addObject:key];
    }
    return temp;
}

+(void)clearHistorySearch
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (userDef) {
        NSArray *historySearchArray = [userDef objectForKey:@"historySearch"];
        if(historySearchArray == nil)
        {
            historySearchArray = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:historySearchArray];
        [temp removeAllObjects];
                //只记录10条搜索
        [userDef setObject:temp forKey:@"historySearch"];
    }
}
@end
