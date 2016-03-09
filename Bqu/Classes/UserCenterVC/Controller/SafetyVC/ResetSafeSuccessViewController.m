//
//  ResetSafeSuccessViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ResetSafeSuccessViewController.h"

@interface ResetSafeSuccessViewController ()

@end

@implementation ResetSafeSuccessViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"手机验证";
    
    [self.sure_Button onlyCornerRadius];
    self.sure_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
}

- (IBAction)sureButtonClick:(id)sender
{
    NSArray *ctrlArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
}


- (void)didReceiveMemoryWarning {
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
