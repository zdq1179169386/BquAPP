//
//  EditToolView.h
//  Bqu
//
//  Created by yb on 15/11/9.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditToolViewDelagate <NSObject>
@optional
-(void)touchDown:(UIButton*)sender;

@end

@interface EditToolView : UIView

@property(nonatomic)UIButton *allSelectBtn;
@property(nonatomic)UILabel *allSelectLab;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic)UIButton *clearBtn;
@property (nonatomic,weak)id<EditToolViewDelagate>delegate;

+(instancetype)editWithframe:(CGRect)frame;

-(void)setIsSelect:(BOOL)Select;
@end
