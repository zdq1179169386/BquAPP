//
//  AddAddressViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@protocol addAddressDelegate <NSObject>

@optional
-(void)addAddressSave:(NSDictionary*)dic;
@end


typedef enum
{
    /**增加地址**/
    OrderStatus_add = 0,
    /**修改地址**/
    OrderStatus_change = 1
    
}Status;


@interface AddAddressViewController : HSViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    /**是否显示城市选择器**/
    BOOL isShow;
    /**城的行**/
    NSInteger row1;
    /**市的行**/
    NSInteger row2;
    /**区的行**/
    NSInteger row3;
    /*是否设置为默认地址*/
    BOOL isDefault;
    
}
// 代理 传值
@property(nonatomic,weak)id<addAddressDelegate>delegate;

/**城市选择器**/
@property (strong, nonatomic) UIPickerView *pickerView;
/**白色背景视图**/
@property (strong, nonatomic) IBOutlet UIView *white_View;
/**收货人lab**/
@property (strong, nonatomic) IBOutlet UILabel *receiver_Lab;
/**收货人输入框**/
@property (strong, nonatomic) IBOutlet UITextField *receiver_TextF;
/**第一条线**/
@property (strong, nonatomic) IBOutlet UIView *line1_View;
/**电话lable**/
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber_Lab;
/**电话输入框**/
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber_TextF;
/**第二条线**/
@property (strong, nonatomic) IBOutlet UIView *line2_View;
/**身份证lab**/
@property (strong, nonatomic) IBOutlet UILabel *idCard_Lab;
/**身份证输入框**/
@property (strong, nonatomic) IBOutlet UITextField *idCard_TextF;
/**第三条线**/
@property (strong, nonatomic) IBOutlet UIView *line3_View;
/**省市区地址lab**/
@property (strong, nonatomic) IBOutlet UILabel *address_Lab;
/**省市区地址输入框(没啥用...)**/
@property (strong, nonatomic) IBOutlet UITextField *address_TextF;
/**第四条线**/
@property (strong, nonatomic) IBOutlet UIView *line4_View;
/**详细地址lab**/
@property (strong, nonatomic) IBOutlet UILabel *detailAddress_Lab;
/**详细地址输入框**/
@property (strong, nonatomic) IBOutlet UITextField *detailAddress_TextF;
/**第五条线**/
@property (strong, nonatomic) IBOutlet UIView *line5_View;
/**小箭头按钮**/
@property (strong, nonatomic) IBOutlet UIButton *arrow_Button;

/**城市数组**/
@property (strong, nonatomic)  NSMutableArray *city_Array;
/****/
@property (strong, nonatomic)  UIButton *contry_Array;
/****/
@property (strong, nonatomic)  NSString *regionId;
/**添加还是修改**/
@property (assign, nonatomic)  Status status;
/****/
@property (strong, nonatomic)  NSString *addressId;

/**修改地址时候,需要传递的变量,显示的时候就不会空,五个输入框按顺序往下排,我懒得写了**/
@property (strong, nonatomic)  NSString *firstT;
@property (strong, nonatomic)  NSString *twoT;
@property (strong, nonatomic)  NSString *threeT;
@property (strong, nonatomic)  NSString *fourT;
@property (strong, nonatomic)  NSString *fourText;
@property (strong, nonatomic)  NSString *fiveT;


/*默认地址试图*/
@property (weak, nonatomic) IBOutlet UIView *defaultView;
/*默认地址图片*/
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;
/*默认地址文字*/
@property (weak, nonatomic) IBOutlet UILabel *defaultLab;
/*默认地址按钮*/
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;


@end
