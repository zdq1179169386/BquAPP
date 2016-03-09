//
//  CommentModel.m
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CommentModel.h"
#define  garpW 10

#define garpH 5
#define iconW  40


@implementation CommentModel

-(NSString *)UserName
{
    NSString * str1 = [_UserName substringToIndex:3];
    NSRange range = NSMakeRange(7, 4);
    NSString * str2 = [_UserName substringWithRange:range];
    
//    NSLog(@"%@,%@",str1,str2);
    
    NSString * str = [NSString stringWithFormat:@"%@****%@",str1,str2];
    return str;
}
-(NSString *)ReviewDate
{
    NSRange range = NSMakeRange(0, _ReviewDate.length -3);
    NSString * str = [_ReviewDate substringWithRange:range];
    return str;
}

@end


@implementation CommentModelFrame

-(void)setComment:(CommentModel *)comment
{
    _comment = comment;
    
    self.UserPhotoF = CGRectMake(garpW, garpW, iconW, iconW);
    
    self.UserNameF = CGRectMake(garpW*2+iconW, garpW, 150, 20);
    
    CGSize size = [comment.ReviewContent sizeWithFont:[UIFont systemFontOfSize:16] maxW:ScreenWidth-garpW*3-iconW];
    self.ReviewContentF = CGRectMake(garpW*2+iconW, garpW*2+20, ScreenWidth-garpW*3-iconW, size.height);
   
    CGFloat dateY = CGRectGetMaxY(self.ReviewContentF);
    self.ReviewDateF = CGRectMake(garpW*2+iconW, dateY+garpW, 150, 20);
    
//    self.ReviewMarkF =  CGRectMake(ScreenWidth-100, dateY+garpW, <#CGFloat width#>, 20);
    
    CGFloat maxY = CGRectGetMaxY(self.ReviewDateF) + garpW;
    
    self.cellHeight = maxY;
}

@end