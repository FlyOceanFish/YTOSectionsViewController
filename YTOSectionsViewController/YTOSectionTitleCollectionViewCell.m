//
//  YTOSectionTitleCollectionViewCell.m
//  testaa
//
//  Created by FlyOceanFish on 2017/8/11.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

#import "YTOSectionTitleCollectionViewCell.h"

@interface YTOSectionTitleCollectionViewCell()

@end

@implementation YTOSectionTitleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}
@end
