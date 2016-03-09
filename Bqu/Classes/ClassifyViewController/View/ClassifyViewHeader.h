//
//  ClassifyViewHeader.h
//  Bqu
//
//  Created by yb on 15/11/23.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ClassifyViewHeaderH 39

@class ClassifyViewHeader;

@protocol ClassifyViewHeaderDelegate <NSObject>

@optional

-(void)ClassifyViewHeaderDelegate:(ClassifyViewHeader*)view with:(UIButton *)btn;

@end

@interface ClassifyViewHeader : UIView


/**代理*/
@property(nonatomic,assign)id<ClassifyViewHeaderDelegate> delegate;

@property (nonatomic,strong)NSMutableArray * buttons;


+(instancetype)creatHeader;
-(void)setupBtn:(int )index;

@end
