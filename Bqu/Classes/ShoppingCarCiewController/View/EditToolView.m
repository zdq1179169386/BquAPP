//
//  EditToolView.m
//  Bqu
//
//  Created by yb on 15/11/9.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "EditToolView.h"

@implementation EditToolView

+(instancetype)editWithframe:(CGRect)frame
{
    EditToolView * editToolView = [[EditToolView alloc] initWithFrame:frame];
    editToolView.backgroundColor = [UIColor whiteColor];
    editToolView.tag = 300;
    
    double w = ScreenWidth/375;
    //新建全选按钮，设置属性，添加点击相应事件 AllSelectTouchDown：将按钮添加到View 中
    editToolView.allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 9, 40, 40)];
    [editToolView.allSelectBtn setImage:[UIImage imageNamed:@"xunfalse.png"] forState:UIControlStateNormal];
    [editToolView.allSelectBtn addTarget:editToolView action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    editToolView.allSelectBtn.tag = 101;
//    editToolView.allSelectBtn.titleLabel.text =  @"全选";
//    editToolView.allSelectBtn.titleLabel.textColor =[UIColor colorWithHexString:@"#333333"];
//    editToolView.allSelectBtn.titleLabel.font =[UIFont systemFontOfSize:13];
    [editToolView addSubview:editToolView.allSelectBtn];
    
    //新建全选Lable，设置属性,添加到View 中
    editToolView.allSelectLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 40, 15)];
    editToolView.allSelectLab.text = @"全选";
    editToolView.allSelectLab.textColor = [UIColor blackColor];
    editToolView.allSelectLab.font = [UIFont systemFontOfSize:13];
    [editToolView addSubview:editToolView.allSelectLab];
    
    //新建删除按钮，设置属性，添加点击相应事件 deleteTouchDown：将按钮添加到View 中

    editToolView.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-10-120*w, 10, 120*w, frame.size.height-20)];
    editToolView.deleteBtn.layer.cornerRadius = 3;
    editToolView.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#E8103C"];
    [editToolView.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [editToolView.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editToolView.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [editToolView.deleteBtn addTarget:editToolView action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    editToolView.deleteBtn.tag = 102;
    [editToolView addSubview:editToolView.deleteBtn];
    
    //新建清理失效按钮，设置属性，添加点击相应事件 clearTouchDown：将按钮添加到View 中
    editToolView.clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth -20-240*w, 10, 120*w, frame.size.height-20)];
    
    editToolView.clearBtn.layer.cornerRadius = 3;
    editToolView.clearBtn.backgroundColor = [UIColor whiteColor];
    [editToolView.clearBtn setTitle:@"清空失效商品" forState:UIControlStateNormal];
    [editToolView.clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editToolView.clearBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [editToolView.clearBtn addTarget:editToolView action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [editToolView.clearBtn.layer setMasksToBounds:YES];//设置矩形四个圆角半径
    //边框宽度
    [editToolView.clearBtn.layer setBorderWidth:1.0];
    //设置边框颜色有两种方法：第一种如下:
    editToolView.clearBtn.layer.borderColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5].CGColor;
    editToolView.clearBtn.tag = 103;
    [editToolView addSubview:editToolView.clearBtn];
    return editToolView;
}

-(void)touchDown:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(touchDown:)]) {
        [self.delegate touchDown:sender];
    }
}

-(void)setIsSelect:(BOOL)Select
{
    if (Select)
    {
        [self.allSelectBtn setImage:[UIImage imageNamed:@"xuntrue" ] forState:UIControlStateNormal];
    }
    else
    {
        [self.allSelectBtn setImage:[UIImage imageNamed:@"xunfalse" ] forState:UIControlStateNormal];
    }
}
@end
