//
//  DeliveryAddressView.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "DeliveryAddressView.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width)


@implementation DeliveryAddressView

//@property (nonatomic)UIButton *selectAllBtn;
//@property (nonatomic)UIImageView *storeHouseImage;
//@property (nonatomic) UILabel *deliveryAddress;
-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        double per = 1;
        if ( ScreenWidth == 414) {
            per = 1.286;
        }

        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39)];
        view.backgroundColor = [UIColor whiteColor];
        
        
        
        self.selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 39)];
        [self.selectAllBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:self.selectAllBtn];
        
        self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 17, 17)];
        [view addSubview:self.selectView];
        
        self.storeHouseImage = [[UIImageView alloc] initWithFrame:CGRectMake(37, 13, 15, 12)];
        self.storeHouseImage.image = [UIImage imageNamed:@"carico"];
        [view addSubview:self.storeHouseImage];
        
        self.deliveryAddress = [[UILabel alloc]  initWithFrame:CGRectMake(62, 13, 200, 15)];
        self.deliveryAddress.font = [UIFont systemFontOfSize:13];
        self.deliveryAddress.textColor = [UIColor colorWithHexString:@"#333333"];
        [view addSubview:self.deliveryAddress];
        
        [self addSubview:view];
    }
    return self;
}

//代理通知 已经被全选

- (void)allSelect:(id)sender
{

   // NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if ([self.delegate respondsToSelector:@selector(allSelectbtnClick:sender:)]) {
        [self.delegate allSelectbtnClick:self sender:_AllSelect ];
    }
}


-(void)setValue:(NSString*)deliveryAddress isAllSelect:(BOOL)isAllSelect
{
    _AllSelect = isAllSelect;
    _deliveryAddress.text = deliveryAddress;
    if (_AllSelect)
    {
        _selectView.image = [UIImage imageNamed:@"xuntrue"];
        
    }else{
        _selectView.image =  [UIImage imageNamed:@"xunfalse"];
    }
    
}

@end
