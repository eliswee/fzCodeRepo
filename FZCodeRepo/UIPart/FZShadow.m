//
//  FZShadow.m
//  FZCodeRepo
//
//  Created by zfz on 2018/8/13.
//  Copyright © 2018年 zhfeze. All rights reserved.
//

#import "FZShadow.h"
#import <Masonry.h>
/** 渐变色 */
@implementation FZShadow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIView *jianbian = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = jianbian.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:1.f alpha:0.f].CGColor,
                       (id)[UIColor colorWithWhite:1.f alpha:1.f].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    [jianbian.layer addSublayer:gradient];
    
    [self addSubview:jianbian];
    [jianbian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@60);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
