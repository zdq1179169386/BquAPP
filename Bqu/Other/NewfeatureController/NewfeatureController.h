//
//  NewfeatureController.h
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NewfeatureController;
@protocol NewfeatureControllerDelagate <NSObject>

-(void)startClickDelegate:(NewfeatureController *)newFeature withBtn:(UIButton *)startBtn;

@end


@interface NewfeatureController : UIViewController

@property(nonatomic,assign)id<NewfeatureControllerDelagate>delegate;
@end

