//
//  AvatarBrowser.m
//  Bqu
//
//  Created by wyy on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AvatarBrowser.h"

@interface AvatarBrowser () <UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *qrImage;

@end

@implementation AvatarBrowser

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
        [self addGestureRecognizer:tap];
        self.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)showImageWithUrl:(NSString *)imageUrl
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-ScreenWidth)/2, ScreenWidth, ScreenWidth)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    imageView.tag = 1;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self addSubview:imageView];
        //backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.qrImage = [UIImage imageWithData:data];
}

- (void)hideImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        [imageView removeFromSuperview];
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    UIView *backgroundView = longPressGesture.view;
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:nil, nil];
        [actionSheet showInView:backgroundView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //保存图片到相册
        if (self.qrImage) {
            UIImageWriteToSavedPhotosAlbum(self.qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    if (error != NULL) {
        msg = @"保存失败";
    }else{
        msg = @"保存成功";
    }
    [ProgressHud showHUDWithView:[UIApplication sharedApplication].keyWindow withTitle:msg withTime:2.0];
}

@end
