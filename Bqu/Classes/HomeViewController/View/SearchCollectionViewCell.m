//
//  SearchCollectionViewCell.m
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@interface SearchCollectionViewCell ()
//@property (nonatomic,strong)UILabel *keyLab;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation SearchCollectionViewCell

- (void)awakeFromNib {
}



+(instancetype)SearchCollectionViewCell:(UICollectionView*)collectionView NSIndexPath:(NSIndexPath*)indexPath;

{
    static NSString * ID = @"searchCell";
    SearchCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SearchCollectionViewCell" owner:nil options:nil]firstObject];
    }
    return cell;
}


-(void)setKeySize:(KeyWordSizeModul *)keySize 
{
    self.lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.lab.layer.borderWidth = 1;
    self.lab.layer.cornerRadius = 5;
    self.lab.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _keySize = keySize;
    self.lab.text = _keySize.keyWord;
 }


-(void)hotSearch
{
    int x = arc4random() %3;
    if (x == 0)
    {
        self.lab.textColor = [UIColor colorWithHexString:@"#F72748"];
        self.lab.layer.borderColor = [UIColor colorWithHexString:@"#F72748"].CGColor;
    }
}
@end
