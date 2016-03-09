//
//  DrawCashAlertView.h
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ApplyForRefundAlertView.h"

@class DrawCashAlertView;

@protocol DrawCashAlertViewDelegate <NSObject>

-(void)DrawCashAlertViewDelegateBtnClick:(DrawCashAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row;
@end

@interface DrawCashAlertView : UIView

/**<#description#>*/
@property(nonatomic,assign)id<DrawCashAlertViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withDelegate:(id)delegate withTitle:(NSString *)title withArray:(NSArray *)array withIndexPath:(NSIndexPath *)index;

@end
