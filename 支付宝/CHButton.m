//
//  CHButton.m
//  支付宝
//
//  Created by 陈欢 on 15/8/15.
//  Copyright (c) 2015年 wanmei. All rights reserved.
//

#import "CHButton.h"

@implementation CHButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =  [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}







- (void)setup
{
    self.userInteractionEnabled = NO;
    
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
}





@end
