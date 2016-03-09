//
//  AddAddressViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AfterSaleOrderModel.h"
#import "HttpEngine.h"
@interface AddAddressViewController ()

@end

@implementation AddAddressViewController

- (void)viewWillAppear:(BOOL)animated
{
    /**返回按钮**/
    [self createBackBar];
    /**导航栏上保存按钮**/
    [self createRightBar];
    
    NSString * path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * filePath = [path stringByAppendingPathComponent:@"city.plist"];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    if (data.length>0)
    {
        [self paserAddressData:data];
    }else
    {
         [self requestRegionData];
    }
}

-(void)paserAddressData:(NSData *)data
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    self.city_Array = [NSMutableArray array];
    self.city_Array = [CityModel objectArrayWithKeyValuesArray:dic[@"data"]];
    [self.pickerView reloadAllComponents];
}
#pragma mark    ---->获取省市级联数据
- (void)requestRegionData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getRegionAddresslUrl];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;

    [HttpTool post:urlStr params:dict success:^(id json)
    {
//        NSLog(@"获取省市级联数据 %@",json[@"data"]);
        
        NSArray *city_Array = [NSArray array];
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        NSString * path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString * filePath = [path stringByAppendingPathComponent:@"city.plist"];

        BOOL  result = [data writeToFile:filePath atomically:YES];
        if (result) {
            NSLog(@"存储成功");
        }
        city_Array = [CityModel objectArrayWithKeyValuesArray:json[@"data"]];
      
        self.city_Array = (NSMutableArray *)city_Array;
        [self.pickerView reloadAllComponents];
            
    } failure:^(NSError *error)
     {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.city_Array = [NSMutableArray array];
    
    NSLog(@"我regoio址 %@",self.fourT);

    self.view.backgroundColor = RGB_A(240, 238, 238);
    if (self.status == 0)
    {
        self.navigationItem.title = @"新增地址";

    }
    else if(self.status == 1)
    {
        self.navigationItem.title = @"修改地址";
        self.receiver_TextF.text = self.firstT;
        self.phoneNumber_TextF.text = self.twoT;
        self.idCard_TextF.text = self.threeT;
        self.address_TextF.text = self.fourT;
        self.detailAddress_TextF.text = self.fiveT;
        self.regionId = self.fourText;
    }

    //初始化城市选择器
    [self initPickerView];
    self.pickerView.hidden = YES;
    
    self.defaultImage.image = [UIImage imageNamed:@"xunfalse"];
}


#pragma mark    ---->  右边保存按钮
- (void)createRightBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:RGB_A(230, 44, 72) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark    ---->  右边保存按钮点击事件
- (void)rightBarClicked
{
    [self.view endEditing:YES];
    NSString *isDefaultStr = [NSString stringWithFormat:@"%@",isDefault?@"true":@"false"];
    if (self.status == 0)
    {
         NSString *str = [self.receiver_TextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str isEqualToString:@""] || [self.phoneNumber_TextF.text isEqualToString:@""] || [self.idCard_TextF.text isEqualToString:@""] ||  [self.regionId isEqualToString:@""] || [self.detailAddress_TextF.text isEqualToString:@""])
        {
             [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
             
        }
        else
        {
            if (self.phoneNumber_TextF.text.length ==11 && [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"] evaluateWithObject:self.phoneNumber_TextF.text])
            {

                [HttpEngine saveAddressWithShopTo:self.receiver_TextF.text withRegionId:self.regionId withPhone:self.phoneNumber_TextF.text withIDCard:self.idCard_TextF.text withdetailAddress:self.detailAddress_TextF.text withisDefault:isDefaultStr success:^(id json)
                {
                    [self hideLoadingView];
                     NSString *resutlCode111 = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                     if ([resutlCode111 isEqualToString:@"0"])
                     {
                         if([self.delegate respondsToSelector:@selector(addAddressSave:)])
                         {
                             NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:5];
                             dic[@"receiver"] =self.receiver_TextF.text;
                             dic[@"regionId"] =self.regionId;
                             dic[@"phoneNumber"] =self.phoneNumber_TextF.text;
                             dic[@"idCard"] =self.idCard_TextF.text;
                             dic[@"detailAddress"] =self.detailAddress_TextF.text;
                             [self.delegate addAddressSave:dic];
                         }
                         [self.navigationController popViewControllerAnimated:NO];
                     }
                     else
                     {
                          [TipView remindAnimationWithTitle:json[@"message"]];
                          
                     }

                    
                } failure:^(NSError *error)
                {
                    [self hideLoadingView];  
                    
                }];
            }
            else
            {
                [TipView remindAnimationWithTitle:@"请输入正确的手机号码"];
            }
        }
    }
    else if(self.status == 1)
    {
        NSString *str = [self.receiver_TextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str isEqualToString:@""] || [self.phoneNumber_TextF.text isEqualToString:@""] || [self.idCard_TextF.text isEqualToString:@""] ||  [self.regionId isEqualToString:@""] || [self.detailAddress_TextF.text isEqualToString:@""])
        {
            [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
            
        }
        else
        {
            if (self.phoneNumber_TextF.text.length ==11 && [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"] evaluateWithObject:self.phoneNumber_TextF.text])
            {
                
                [HttpEngine updateAddressWithaddressID:self.addressId withShopTo:self.receiver_TextF.text withRegionId:self.regionId withPhone:self.phoneNumber_TextF.text withIDCard:self.idCard_TextF.text withdetailAddress:self.detailAddress_TextF.text withisDefault:isDefaultStr success:^(id json)
                 {
                     [self hideLoadingView];
                     NSString *resutlCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                     if ([resutlCode isEqualToString:@"0"])
                     {
                         [self.navigationController popViewControllerAnimated:NO];
                     }
                     else
                     {
                         [TipView remindAnimationWithTitle:json[@"message"]];
                         
                     }
                     
                     
                 } failure:^(NSError *error)
                 {
                     [self hideLoadingView];
                     
                 }];
            }
            else
            {
                [TipView remindAnimationWithTitle:@"请输入正确的手机号码"];
            }
        }
      
    }

}


#pragma mark    ---->  初始化城市选择器

- (void)initPickerView
{
    row1 = 0;
    row2 = 0;
    row3 = 0;
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight-162-70, ScreenWidth, 162)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];

    [self.pickerView reloadAllComponents];//刷新UIPickerView
    
}

#pragma mark     ---->     pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return  self.city_Array.count;
    }
    else if(component==1)
    {
        if (self.city_Array.count>0) {
            CityModel *city = self.city_Array[row1];
            NSMutableArray *array = city.City;
            if (array)
            {
                return array.count;
            }
           
        }
        return 0;
    }
    else
    {
        if (self.city_Array.count>0) {
            CityModel *city = self.city_Array[row1];
            NSMutableArray *array = city.City;
            if ((NSNull*)array != [NSNull null])
            {
                CountryModel *contry =  city.City[row2];
                NSMutableArray *array1 = contry.County;
                
                if ((NSNull*)array1 != [NSNull null])
                {
                    return array1.count;
                }
                return 0;
            }

        }
        return 0;
    }

}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20.0f;
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return  self.view.frame.size.width/3;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        CityModel *city = self.city_Array[row];
        return city.Name;
    }
    else if (component == 1)
    {
        CityModel *city = self.city_Array[row1];
        NSMutableArray *array = city.City;
        CountryModel *contry =  array[row];
        NSLog(@"市的名字: %@",contry.Name);
        return contry.Name;
    }
    else if (component == 2)
    {
        CityModel *city = self.city_Array[row1];
        NSMutableArray *array = city.City;
        CountryModel *contry =  array[row2];
        NSMutableArray *array1 = contry.County;
        RegionModel *region =  array1[row];
        NSLog(@"区的名字: %@",region.Name);
        return region.Name;
    }
    return nil;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        row1 = row;
        row2 = 0;
        row3 = 0;
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        
    }
    else if (component == 1)
    {
        row2 = row;
        row3 = 0;
        [self.pickerView reloadComponent:2];
    }
    else {
        row3 = row;
    }

    NSInteger cityRow1 = [self.pickerView selectedRowInComponent:0];
    NSInteger cityRow2 = [self.pickerView selectedRowInComponent:1];
    NSInteger cityRow3 = [self.pickerView selectedRowInComponent:2];
    
    NSMutableString *str = [[NSMutableString alloc]init];
    CityModel *city = self.city_Array[cityRow1];
    [str appendString:city.Name];
    self.regionId =  city.Id;
    NSMutableArray *array = city.City;
    
    if ((NSNull*)array != [NSNull null])
    {
        CountryModel *contry =  array[cityRow2];
        [str appendString:contry.Name];
        self.regionId =  contry.Id;

        NSMutableArray *array1 = contry.County;
        if ((NSNull*)array1 != [NSNull null] && array1.count>0 && cityRow3 <= array1.count)
        {
            RegionModel *region = array1[cityRow3];
            [str appendString:region.Name];
            self.regionId =  region.Id;

        }
    }
    self.address_TextF.text = str;
    
}


//每行显示的文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if(component == 0)
    {
        CityModel *city = self.city_Array[row];
        
        titleLabel.text = city.Name;
    }
    else if (component == 1)
    {
        CityModel *city = self.city_Array[row1];
        NSMutableArray *array = city.City;
        CountryModel *contry =  array[row];
        titleLabel.text = contry.Name;
    }
    else if (component == 2)
    {
        CityModel *city = self.city_Array[row1];
        NSMutableArray *array = city.City;
        CountryModel *contry =  array[row2];
        NSMutableArray *array1 = contry.County;
        RegionModel *region =  array1[row];
        titleLabel.text = region.Name;
    }

    return titleLabel;
    
}


#pragma mark    ---->小箭头按钮点击事件
- (IBAction)arrowButtionClick:(id)sender
{
    [self.view endEditing:YES];

    isShow = !isShow;
    if (isShow)
    {
        self.pickerView.hidden = NO;
    }
    else
    {
        self.pickerView.hidden = YES;
    }
    
    
}

#pragma mark
#pragma mark 设置默认地址点击事件

- (IBAction)setDefaultAddressClick:(id)sender
{
    isDefault = !isDefault;
    if (isDefault)
    {
        self.defaultImage.image = [UIImage imageNamed:@"xuntrue"];
    }
    else
    {
        self.defaultImage.image = [UIImage imageNamed:@"xunfalse"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
