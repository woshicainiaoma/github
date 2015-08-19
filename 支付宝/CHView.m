//
//  CHView.m
//  支付宝
//
//  Created by 陈欢 on 15/8/15.
//  Copyright (c) 2015年 wanmei. All rights reserved.
//

#import "CHView.h"
#import "CHButton.h"
@interface CHView()
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic, assign) CGPoint currentMovePoint;
@end
@implementation CHView

- (NSMutableArray *)selectedButtons
{
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

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
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    for (int index = 0; index<9; index++) {
        CHButton *btn = [CHButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = index;
        
        [self addSubview:btn];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int index = 0; index<self.subviews.count; index++) {
        CHButton *btn = self.subviews[index];
        
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        int totalColumns = 3;
        int col = index % totalColumns;
        int row = index / totalColumns;
        
        CGFloat marginX = (self.frame.size.width - totalColumns * btnW) / (totalColumns + 1);
        CGFloat marginY = marginX;
        
        CGFloat btnX = marginX + col * (btnW + marginX);
        CGFloat btnY = row * (btnH + marginY);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        
    }
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:touch.view];
}

- (CHButton *)buttonWithPoint:(CGPoint)point
{
    for (CHButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentMovePoint = CGPointZero;
    CGPoint pos = [self pointWithTouches:touches];
    
    CHButton *btn = [self buttonWithPoint:pos];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
        
        [self setNeedsDisplay];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [self pointWithTouches:touches];
    
    CHButton *btn = [self buttonWithPoint:pos];
    
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
    }else{
        self.currentMovePoint = pos;
    }
    
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delgate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *path = [NSMutableString string];
        for (CHButton *btn in self.selectedButtons) {
            [path appendFormat:@"%d",btn.tag];
        }
        [self.delgate lockView:self didFinishPath:path];
    }
    [self.selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    [self.selectedButtons removeAllObjects];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


- (void)drawRect:(CGRect)rect
{
    if (self.selectedButtons.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 遍历所有的按钮
    for (int index = 0; index<self.selectedButtons.count; index++) {
        CHButton *btn = self.selectedButtons[index];
        
        if (index == 0) {
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    // 连接
    if (CGPointEqualToPoint(self.currentMovePoint, CGPointZero) == NO) {
        [path addLineToPoint:self.currentMovePoint];
    }
    
    // 绘图
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineJoinBevel;
    //    [[UIColor greenColor] set];
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
}
































@end
