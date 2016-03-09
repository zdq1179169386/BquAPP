//
//  ApplyForRefundAlertView.h
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplyForRefundAlertView;

@protocol ApplyForRefundAlertViewDelaget <NSObject>

-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row;
@end


@interface ApplyForRefundAlertView : UIView<UITableViewDataSource,UITableViewDelegate>


/**<#description#>*/
@property(nonatomic,assign)id<ApplyForRefundAlertViewDelaget> delegate;


- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate withTitle:(NSString *)title withArray:(NSArray *)array withIndexPath:(NSIndexPath *)index;

@end
