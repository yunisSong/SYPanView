# SYPanView

### 1，如何绘制弧形间隔的刻度线。
首先是如何绘制一个连续的弧形线条，这个很简单：

```
    UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:cneter radius:radius - 12 startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    perLayer.strokeColor = strokeColor.CGColor;;
    perLayer.fillColor = [UIColor clearColor].CGColor;
    perLayer.allowsEdgeAntialiasing=YES;
    perLayer.contentsScale = [UIScreen mainScreen].scale;
    perLayer.lineWidth   = 0.6;
    perLayer.path = tickPath.CGPath;
    [self.layer addSublayer:perLayer];
```

其实带有间隔的刻度线原理是跟这个一致的，我们只需要想着每个分割的刻度是一个连续的圆弧线，只不过它的 `startAngle` 和 `endAngle` 差值很小。然后外面其实的一段段的绘制一个个 `CAShapeLayer` 的弧线。

具体的代码就是：

```
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
```

其中 `scaleLineCount` 是要分成多少刻度。 

### 2，如何给进度加上动画
动画就简单粗暴了，一个个修改 `CAShapeLayer` 的背景色。


```
CAShapeLayer *perLayer = self.layerViewsArray[self.index];
perLayer.strokeColor = self.hightColor.CGColor;;
[self.layerHeightViewsArray addObject:perLayer];
```
