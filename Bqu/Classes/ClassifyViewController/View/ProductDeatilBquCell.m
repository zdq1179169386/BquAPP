//
//  ProductDeatilBquCell.m
//  Bqu
//
//  Created by yb on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDeatilBquCell.h"

@implementation ProductDeatilBquCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, 100)];
        image.image = [UIImage imageNamed:@"B区保障"];
        [self.contentView addSubview:image];
        image.size = CGSizeMake(image.image.size.width-20, image.image.size.height);
        image.center = CGPointMake(ScreenWidth*0.5, image.image.size.height/2.0+20);
        
        CGFloat line1Y = CGRectGetMaxY(image.frame);
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, line1Y+20, ScreenWidth, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line1];
        
        NSString * str = @"常见问题 COMMON PROBLEMS";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[str rangeOfString:@"常见问题 "]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str rangeOfString:@"产品信息 "]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:@"COMMON PROBLEMS"]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:[str rangeOfString:@"COMMON PROBLEMS"]];
        UILabel * question = [[UILabel alloc] initWithFrame:CGRectMake(10, line1Y+20, 250, 40)];
        question.attributedText = attrStr;
        [self.contentView addSubview:question];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, line1Y+60, ScreenWidth-20, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line2];

        NSString * subStr1 = @"Q1.你们的实体店有哪些?";
        NSString * subStr2 = @"答：目前我们在杭州、温州、宁波拥有15家线下实体体验店,主要分布在大型商场,不久后，会在全国主要一、二、三、线城市。";
        
        NSString * str1 = [NSString stringWithFormat:@"%@\n\n%@",subStr1,subStr2];
        NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
        // 添加属性
        [attrStr1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str1 rangeOfString:subStr1]];
        [attrStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str1 rangeOfString:subStr1]];
        [attrStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str1 rangeOfString:subStr2]];
        [attrStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str1 rangeOfString:subStr2]];
        
        UILabel * answer1 = [[UILabel alloc] initWithFrame:CGRectMake(10, line1Y+60, ScreenWidth-20, 100)];
        answer1.attributedText = attrStr1;
        answer1.numberOfLines = 0;
        [self.contentView addSubview:answer1];
        
        CGFloat line3Y = CGRectGetMaxY(answer1.frame);
        
        UILabel * line3 = [[UILabel alloc] initWithFrame:CGRectMake(10, line3Y, ScreenWidth-20, 1)];
        line3.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line3];
        
        NSString * subStrQ1 = @"Q2.如何保证你们网站的商品是国外正品？";
        NSString * subStrQ2 = @"答：我们从源头开始监控，产地制裁、海/空运输直至到达国内保税仓都将由B区自主完成。并且，国家各保税区海关会对所有商品进行严格的质检，合格后才会清关并由B区发往各位消费者手中。";
        
        NSString * str2 = [NSString stringWithFormat:@"%@\n\n%@",subStrQ1,subStrQ2];
        NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
        // 添加属性
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str2 rangeOfString:subStrQ1]];
        [attrStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str2 rangeOfString:subStrQ1]];
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str2 rangeOfString:subStrQ2]];
        [attrStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str2 rangeOfString:subStrQ2]];
        
        UILabel * answer2 = [[UILabel alloc] initWithFrame:CGRectMake(10, line3Y, ScreenWidth-20, 100)];
        answer2.attributedText = attrStr2;
        answer2.numberOfLines = 0;
        [self.contentView addSubview:answer2];
        
        UILabel * line4 = [[UILabel alloc] initWithFrame:CGRectMake(10, line3Y+100, ScreenWidth-20, 1)];
        line4.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line4];
        
        NSString * subStr31 = @"Q3.通常我下单后多久可以收到?";
        NSString * subStr32 = @"答：下单后，海关在72小时内进行审核清关，然后B区直接使用快递发出。3~7天即可收到所购买的商品。";
        
        NSString * str3 = [NSString stringWithFormat:@"%@\n\n%@",subStr31,subStr32];
        NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:str3];
        // 添加属性
        [attrStr3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str3 rangeOfString:subStr31]];
        [attrStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str3 rangeOfString:subStr31]];
        [attrStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]range:[str3 rangeOfString:subStr32]];
        [attrStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str3 rangeOfString:subStr32]];
        
        UILabel * answer3 = [[UILabel alloc] initWithFrame:CGRectMake(10, line3Y+100, ScreenWidth-20, 100)];
        answer3.attributedText = attrStr3;
        answer3.numberOfLines = 0;
        [self.contentView addSubview:answer3];
        
        CGFloat line5Y = CGRectGetMaxY(answer3.frame);
        UILabel * line5 = [[UILabel alloc] initWithFrame:CGRectMake(10, line5Y, ScreenWidth-20, 1)];
        line5.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line5];

        
        NSString * subStr41 = @"Q4.收到包裹后，发现有缺损的状况，能申请赔偿吗？";
        NSString * subStr42 = @"答：买家签收时，请务必线开箱检查商品，确认无误后再签收若签收前验货时发现商品破损，请在24小时内联系客服，并提供破损的照片，我们客服收到您的反馈后会第一时间为您处理。";
        
        NSString * str4 = [NSString stringWithFormat:@"%@\n\n%@",subStr41,subStr42];
        NSMutableAttributedString *attrStr4 = [[NSMutableAttributedString alloc] initWithString:str4];
        // 添加属性
        [attrStr4 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str4 rangeOfString:subStr41]];
        [attrStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str4 rangeOfString:subStr41]];
        [attrStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str4 rangeOfString:subStr42]];
        [attrStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str4 rangeOfString:subStr42]];
        
        UILabel * answer4 = [[UILabel alloc] initWithFrame:CGRectMake(10, line5Y, ScreenWidth-20, 120)];
        answer4.attributedText = attrStr4;
        answer4.numberOfLines = 0;
        [self.contentView addSubview:answer4];
        
        CGFloat line6Y = CGRectGetMaxY(answer4.frame);
        UILabel * line6 = [[UILabel alloc] initWithFrame:CGRectMake(10, line6Y, ScreenWidth-20, 1)];
        line6.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line6];
        
        NSString * subStr51 = @"Q5.三单合一是指什么？为什么要这样？";
        NSString * subStr52 = @"答：就B区而言，根据国家相关法律法规，凡用户购买享受免税政策的海外商品，必须在B区网站下单，且需要保证购物订单、快递单、银行付款订单信息一致（即三单合一），即可通过海关审查。";
        
        NSString * str5 = [NSString stringWithFormat:@"%@\n\n%@",subStr51,subStr52];
        NSMutableAttributedString *attrStr5 = [[NSMutableAttributedString alloc] initWithString:str5];
        // 添加属性
        [attrStr5 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str5 rangeOfString:subStr51]];
        [attrStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str5 rangeOfString:subStr51]];
        [attrStr5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str5 rangeOfString:subStr52]];
        [attrStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str5 rangeOfString:subStr52]];
        
        UILabel * answer5 = [[UILabel alloc] initWithFrame:CGRectMake(10, line6Y, ScreenWidth-20, 110)];
        answer5.attributedText = attrStr5;
        answer5.numberOfLines = 0;
        [self.contentView addSubview:answer5];
        
        CGFloat line7Y = CGRectGetMaxY(answer5.frame);
        UILabel * line7 = [[UILabel alloc] initWithFrame:CGRectMake(10, line7Y, ScreenWidth-20, 1)];
        line7.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line7];

        NSString * subStr61 = @"Q6.你们的运费是如何计算的？";
        NSString * subStr62 = @"答：用户购买B区商品所产生的运费即一般是国内快递商所收的费用，具体费用以国内快递商所收费用为准。";
        
        NSString * str6 = [NSString stringWithFormat:@"%@\n\n%@",subStr61,subStr62];
        NSMutableAttributedString *attrStr6 = [[NSMutableAttributedString alloc] initWithString:str6];
        // 添加属性
        [attrStr6 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str6 rangeOfString:subStr61]];
        [attrStr6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str6 rangeOfString:subStr61]];
        [attrStr6 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str6 rangeOfString:subStr62]];
        [attrStr6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str6 rangeOfString:subStr62]];
        
        UILabel * answer6 = [[UILabel alloc] initWithFrame:CGRectMake(10, line7Y, ScreenWidth-20, 100)];
        answer6.attributedText = attrStr6;
        answer6.numberOfLines = 0;
        [self.contentView addSubview:answer6];
        
        CGFloat line8Y = CGRectGetMaxY(answer6.frame);
        UILabel * line8 = [[UILabel alloc] initWithFrame:CGRectMake(10, line8Y, ScreenWidth-20, 1)];
        line8.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line8];
        
        
        NSString * userStr = @"消费者告知书 CONSUMERS NOTICE";
        NSMutableAttributedString *userAttrStr = [[NSMutableAttributedString alloc] initWithString:userStr];
        // 添加属性
        [userAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[userStr rangeOfString:@"消费者告知书 "]];
        [userAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[userStr rangeOfString:@"消费者告知书 "]];
        [userAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[userStr rangeOfString:@"CONSUMERS NOTICE"]];
        [userAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:[userStr rangeOfString:@"CONSUMERS NOTICE"]];
        UILabel * notify = [[UILabel alloc] initWithFrame:CGRectMake(10, line8Y, 300, 40)];
        notify.attributedText = userAttrStr;
        [self.contentView addSubview:notify];
        
        CGFloat line9Y = CGRectGetMaxY(notify.frame);
        UILabel * line9 = [[UILabel alloc] initWithFrame:CGRectMake(10, line9Y, ScreenWidth-20, 1)];
        line9.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line9];
        
        NSString * notify1 = @"尊敬的用户：";
        
        NSString * notify2 = @"在您选购境外商品前，麻烦您仔细阅读此文，同意本文所告知内容后再进行下单购买：";
        
        NSString * notify3 = @"1 本站商品均在海外销售，我们承诺正规渠道，100%正品保证。";
        
        NSString * notify4 = @"2 您在本（公司）网站上购买的境外商品为产地直销商品，仅限个人自用不得进行销售,商品本身可能无中文标签，您可以参考官网翻译。";

        NSString * notify5 = @"3 您购买的境外商品适用的品质、健康、标识等项目适用标准或与我国标准有所不同，所以在使用过程中由此可能产生的危害或损失以及其他风险，将由您个人承担。";
        NSString * notify6 = @"4 由于跨境电商的特殊性，如下单并付款后是【已付款，海关清关中】的状态后，系统会自动将订单推送到海外仓或者保税仓锁定库存，所以无法取消订单。只能等到商品被您签收后，进行退货申请。";
        
        
        NSString * notifyStr = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@",notify1,notify2,notify3,notify4,notify5,notify6];
        
        NSMutableAttributedString *notifyAttrStr = [[NSMutableAttributedString alloc] initWithString:notifyStr];
        
        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[notifyStr rangeOfString:notify1]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify1]];
        
        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[notifyStr rangeOfString:notify2]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify2]];

        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]range:[notifyStr rangeOfString:notify3]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify3]];
        
        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[notifyStr rangeOfString:notify4]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify4]];
        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[notifyStr rangeOfString:notify5]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify5]];
        [notifyAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[notifyStr rangeOfString:notify6]];
        [notifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[notifyStr rangeOfString:notify6]];
        NSLog(@"line9Y=%f",line9Y);
        UILabel * notifyContent = [[UILabel alloc] initWithFrame:CGRectMake(10, line9Y, ScreenWidth-20, 300)];
        notifyContent.numberOfLines = 0;
        notifyContent.attributedText = notifyAttrStr;
        [self.contentView addSubview:notifyContent];
        
        CGFloat notifyY = CGRectGetMaxY(notifyContent.frame);
        
        UILabel * line10 = [[UILabel alloc] initWithFrame:CGRectMake(10, notifyY, ScreenWidth-20, 1)];
        line10.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line10];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
