//
//  SYPaneView.m
//  SYPanView
//
//  Created by Yunis on 2017/8/18.
//  Copyright © 2017年 Yunis. All rights reserved.
//

#import "SYPaneView.h"
#import <QuartzCore/QuartzCore.h>
@interface SYPaneView()
@property (nonatomic,strong) NSMutableArray <CAShapeLayer *>*layerViewsArray;/**<记录刻度视图*/
@property (nonatomic,strong) NSMutableArray <CAShapeLayer *>*layerHeightViewsArray;/**<记录高亮刻度视图*/
@property (nonatomic,strong) UILabel      *toTaskNumLabel;
@property (nonatomic,strong) UILabel      *desLabel;
@property (nonatomic,strong) NSTimer      *animationTimer;
@property (nonatomic       ) int          index;
@end
@implementation SYPaneView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self assignDate];
        [self loadSubViews];
    }
    return self;
}
- (void)dealloc
{
    
}
#pragma mark - Intial Methods
//初始化数据
- (void)assignDate
{
    self.radius         = 72;
    self.index          = 0;
    self.startAngle     = -5*M_PI/4;
    self.endAngle       = M_PI/4;
    self.scaleLineWidth = 5;
    self.scaleLineCount = 100;
    self.normalColor    = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.3];
    self.hightColor     = [UIColor whiteColor];
}
- (void)loadSubViews
{
    [self drawBaseView];
    [self addSubview:self.toTaskNumLabel];
    [self addSubview:self.desLabel];
}

#pragma mark - Public Method
//外部方法

#pragma mark - Private Method
- (void)drawBaseView
{
    [self drawBaseScaleWithStartAngle:self.startAngle
                             endAngle:self.endAngle
                       scaleLineWidth:self.scaleLineWidth
                       scaleLineCount:self.scaleLineCount];
}
- (void)drawBaseScaleWithStartAngle:(CGFloat)startAngle
                           endAngle:(CGFloat)endAngle
                     scaleLineWidth:(CGFloat)scaleLineWidth
                     scaleLineCount:(CGFloat)scaleLineCount
{
    CGPoint cneter = self.center;
    CGFloat radius = self.radius;
    CGFloat perAngle = (endAngle - startAngle)/scaleLineCount;
    UIColor *strokeColor = self.normalColor;
    //绘制最外围刻度列表
    for (NSInteger i = 0; i<= scaleLineCount; i++) {
        CGFloat startAngel = (startAngle+ perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:cneter radius:radius startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = strokeColor.CGColor;;
        perLayer.allowsEdgeAntialiasing=YES;
        perLayer.contentsScale = [UIScreen mainScreen].scale;
        perLayer.lineWidth   = scaleLineWidth;
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
        [self.layerViewsArray addObject:perLayer];
    }
    //绘制内圈原
    UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:cneter radius:radius - 12 startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    perLayer.strokeColor = strokeColor.CGColor;;
    perLayer.fillColor = [UIColor clearColor].CGColor;
    perLayer.allowsEdgeAntialiasing=YES;
    perLayer.contentsScale = [UIScreen mainScreen].scale;
    perLayer.lineWidth   = 0.6;
    perLayer.path = tickPath.CGPath;
    [self.layer addSublayer:perLayer];
}

-(void)showHightColor:(NSTimer *)time{
    if (self.todoTask == 0 || self.allTaskCount == 0) {
        [self resetDate];
        return;
    }
    float percentage = (self.todoTask * 1.0)/self.allTaskCount;
    if (percentage > 1) {
        percentage = 1;
    }
    int count =(int)(self.layerViewsArray.count * percentage) - 1;
    if (self.index >= count) {
        [self resetDate];
        return;
    }
    if (self.index < self.layerViewsArray.count)
    {
        CAShapeLayer *perLayer = self.layerViewsArray[self.index];
        perLayer.strokeColor = self.hightColor.CGColor;;
        [self.layerHeightViewsArray addObject:perLayer];
    }
    self.index++;
}

- (void)resetDate {
    self.index = 0;
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}
#pragma mark - Delegate
//代理方法
- (void)showNormalColor{
    [self.layerHeightViewsArray enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull perLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        perLayer.strokeColor = self.normalColor.CGColor;;
    }];
    [self.layerHeightViewsArray removeAllObjects];
}

#pragma mark - Lazy Loads
//懒加载 Getter方法
- (NSMutableArray <CAShapeLayer *>*)layerViewsArray{
    if (_layerViewsArray == nil) {
        _layerViewsArray = ({
            NSMutableArray <CAShapeLayer *>*marray = [NSMutableArray new];
            marray;
        });
    }
    return _layerViewsArray;
}

- (NSMutableArray <CAShapeLayer *>*)layerHeightViewsArray{
    if (_layerHeightViewsArray == nil) {
        _layerHeightViewsArray = ({
            NSMutableArray <CAShapeLayer *>*marray = [NSMutableArray new];
            marray;
        });
    }
    return _layerHeightViewsArray;
}

- (UILabel *)toTaskNumLabel{
    if (_toTaskNumLabel == nil) {
        _toTaskNumLabel = ({
            UILabel *speedLabel      = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 80, 80}];
            speedLabel.center        = self.center;
            speedLabel.font          = [UIFont boldSystemFontOfSize:30.0f];
            speedLabel.textAlignment = NSTextAlignmentCenter;
            speedLabel.textColor     = [UIColor whiteColor];
            speedLabel.text          = @"0";
            speedLabel;
        });
    }
    
    return _toTaskNumLabel;
}

- (UILabel *)desLabel{
    if (_desLabel == nil) {
        _desLabel = ({
            UILabel * label                 = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x- 60,self.center.y + 15, 120, 30)];
            label.text                      = @"未完成任务";
            label.font                      = [UIFont systemFontOfSize:14];
            label.textAlignment             = NSTextAlignmentCenter;
            label.textColor                 = [UIColor whiteColor];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
    }
    
    return _desLabel;
}

- (NSTimer *)animationTimer{
    if (_animationTimer == nil) {
        _animationTimer = ({
            NSTimer *animationTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(showHightColor:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
            animationTimer;
        });
    }
    
    return _animationTimer;
}
#pragma mark - set
//Setter方法
- (void)setTodoTask:(NSInteger)todoTask
{
    if (_todoTask != todoTask) {
        [self showNormalColor];
        _todoTask = todoTask;
        self.toTaskNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_todoTask];
        if (_todoTask != 0) {
            [self.animationTimer fire];
        }
    }
}
@end
