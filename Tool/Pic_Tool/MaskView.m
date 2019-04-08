
//
//  MaskView.m
//  Tool
//
//  Created by walen on 2019/4/2.
//  Copyright © 2019 walen. All rights reserved.
//

#import "MaskView.h"
#import "MaskLayer.h"
#import <CoreGraphics/CoreGraphics.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface MaskView ()<CAAnimationDelegate>
{
    CGPoint previous_P;
    CGPoint current_P;
    
    float scale;

    CGPoint offset_P;
    
    CGPoint recordOffset;//记录移动完成后可偏移距离
}

@property (nonatomic,strong)RotateLayer *r_layer;
@property (nonatomic,strong)MaskLayer *mask_layer;
@property (nonatomic,assign)BOOL isAnimal;//是否在移动

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        scale = 1.0;
        self.rotateType = KRotateAngle_360;
        offset_P = CGPointMake(self.center.x, self.center.y);
        
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor blackColor];
        
        //显示图层
        [self.layer addSublayer:self.r_layer];
        
        //遮罩
        [self.layer addSublayer:self.mask_layer];
        
        //捏合手势
        UIPinchGestureRecognizer *pinchG = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGAction:)];
        [self addGestureRecognizer:pinchG];
        
        //属性监听
        [self addObserver:self forKeyPath:@"isAnimal" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        //绘制
        [self drawImage];
        
        //通知结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus) name:@"ListenRotateStatus" object:nil];
    }
    return self;
}


- (void)changeStatus
{
    self.isAnimal = false;
}

//属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isAnimal"]) {
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue.intValue == 1) {
            self.mask_layer.hidden = YES;
        }else{
            self.mask_layer.hidden = NO;
        }
    }
}

- (void)pinchGAction:(UIPinchGestureRecognizer *)pinchG
{
    UIGestureRecognizerState state = pinchG.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            pinchG.scale = scale;
            self.isAnimal = true;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.isAnimal = true;
            scale = pinchG.scale;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.isAnimal = false;
        }
            break;
        default:
            break;
    }
    
    [self drawImage];
}


- (RotateLayer *)r_layer
{
    if (!_r_layer) {
        _r_layer = [[RotateLayer alloc] init];
        _r_layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _r_layer;
}

- (MaskLayer *)mask_layer
{
    if (!_mask_layer) {
        _mask_layer = [[MaskLayer alloc] init];
        _mask_layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _mask_layer;
}

- (void)drawImage
{
    //旋转图片
    UIImage *rotateIMG = [UIImage imageNamed:@"timg.jpeg"];
    
    //缩放比例
    float wh_rate = rotateIMG.size.width/rotateIMG.size.height;
    float w_scale = 0.0;
    float h_scale = 0.0;
    
    // Drawing code
    CGPoint offset = [self coordinateOffset:&current_P andPrevious_P:&previous_P];
    float standard = scale > 1.0 ? 300.0 * scale:300.0;
    
    if (rotateIMG.size.width > rotateIMG.size.height) {
        h_scale = 300.0/rotateIMG.size.height;
        w_scale = h_scale * wh_rate;
        
        //平移
        CGRect recordArea = [self isExistArea:CGRectMake(offset_P.x-standard/2/w_scale+offset.x, offset_P.y-standard/2+offset.y, standard/w_scale, standard)];
        recordOffset = CGPointMake(recordArea.origin.x - (offset_P.x-standard/2/w_scale), recordArea.origin.y - (offset_P.y-standard/2));
        //        [rotateIMG drawInRect:CGRectMake(offset_P.x-standard/2/w_scale+recordOffset.x, offset_P.y-standard/2+recordOffset.y, standard/w_scale, standard)];
        
        //动画层
        [self.r_layer drawMaskImage:rotateIMG andRect:CGRectMake(offset_P.x-self.center.x+recordOffset.x, offset_P.y-self.center.y+recordOffset.y, standard/w_scale, standard)];
        
        
    }else{
        w_scale = 300.0/rotateIMG.size.width;
        h_scale = w_scale/wh_rate;
        
        //平移
        CGRect recordArea = [self isExistArea:CGRectMake(offset_P.x-standard/2+offset.x, offset_P.y-standard/2/h_scale+offset.y, standard, standard/h_scale)];
        recordOffset = CGPointMake(recordArea.origin.x - (offset_P.x-standard/2), recordArea.origin.y - (offset_P.y-standard/2/h_scale));
        //        [rotateIMG drawInRect:CGRectMake(offset_P.x-standard/2+recordOffset.x, offset_P.y-standard/2/h_scale+recordOffset.y, standard, standard/h_scale)];
        
        //动画层
        [self.r_layer drawMaskImage:rotateIMG andRect:CGRectMake(recordOffset.x, recordOffset.y, standard, standard/h_scale)];
        
        
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //缩放
//    CGContextScaleCTM(context, w_scale, h_scale);
    
    //裁剪自定义区域
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, 1000, 0);
//    CGContextAddLineToPoint(context, 0, 1000);
//    CGContextClosePath(context);
//
//    CGContextClip(context);

}

- (CGPoint)coordinateOffset:(CGPoint *)c_point andPrevious_P:(CGPoint *)p_point
{
    //坐标变换
    switch (self.rotateType) {
        case KRotateAngle_90:
        {
            return CGPointMake(-c_point->y + p_point->y, c_point->x - p_point->x);
        }
            break;
        case KRotateAngle_180:
        {
            return CGPointMake(-c_point->x + p_point->x, -c_point->y + p_point->y);
        }
            break;
        case KRotateAngle_270:
        {
            return CGPointMake(c_point->y - p_point->y, -c_point->x + p_point->x);
        }
            break;
        case KRotateAngle_360:
        {
            return CGPointMake(c_point->x - p_point->x, c_point->y - p_point->y);
        }
            break;
        default:
            break;
    }
}

//clip
- (UIImage *)clipImage
{
    //截取部分图片并生成新图片
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef newImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake((self.center.x-150)*[UIScreen mainScreen].scale, (self.center.y-150)*[UIScreen mainScreen].scale, 300*[UIScreen mainScreen].scale, 300*[UIScreen mainScreen].scale));
   return [UIImage imageWithCGImage:newImage];
}

//reset
- (void)resetImage
{
//    //旋转方向
//    self.rotateType = 0;
//
//    //刷新UI
//    [self setNeedsDisplay];
}

//rotate
- (void)rotateImage
{
    //防止重复点击
    if (!self.isAnimal) {
        self.isAnimal = true;
        static int count = 1;
        
        //旋转方向
        self.rotateType = count % 4;
        NSLog(@"%lu",(unsigned long)self.rotateType);
        
        //旋转
        [self.r_layer rotateLayer];
        
        count ++;
    }
}


// move
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isAnimal = true;
    
    UITouch *touch = [[touches allObjects] lastObject];
    
    //记录起始点
    previous_P = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    
    //记录起始点
    current_P = [touch locationInView:self];
//    NSLog(@"touchBegin ~ %@   touchesMove ~ %@",NSStringFromCGPoint(previous_P),NSStringFromCGPoint(current_P));

    [self drawImage];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //回到中间区域
    self.isAnimal = false;
    offset_P = CGPointMake(offset_P.x + recordOffset.x, offset_P.y + recordOffset.y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //回到中间区域
    self.isAnimal = false;
    offset_P = CGPointMake(offset_P.x + recordOffset.x, offset_P.y + recordOffset.y);
}

//判断在区域中
- (CGRect)isExistArea:(CGRect)area
{
    CGRect clip_rect = CGRectMake(self.center.x - 150, self.center.y - 150, 300, 300);

    CGPoint position = CGPointMake(area.origin.x, area.origin.y);
    if (position.x > clip_rect.origin.x) {
        position.x = clip_rect.origin.x;
    }

    if (position.y > clip_rect.origin.y) {
        position.y = clip_rect.origin.y;
    }

    if (CGRectGetMaxX(area) < CGRectGetMaxX(clip_rect)) {
        position.x = CGRectGetMaxX(clip_rect)-area.size.width;
    }
    if (CGRectGetMaxY(area) < CGRectGetMaxY(clip_rect)) {
        position.y = CGRectGetMaxY(clip_rect)-area.size.height;
    }

    //记录位置
//    NSLog(@"%@",NSStringFromCGPoint(position));
    return CGRectMake(position.x, position.y, area.size.width, area.size.height);
}


//图片旋转
//- (UIImage *)rotateImage:(UIImage *)img andDirection:(KRotateAngleType)type
//{
//    //旋转
//    long double rotate = 0.0;
//    CGRect imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
//    float translateX = 0;
//    float translateY = 0;
//    float scaleX = 1.0;
//    float scaleY = 1.0;
//
//    switch (type) {
//        case KRotateAngle_90:
//        {
//            rotate = M_PI_2;
//            imgRect = CGRectMake(0, 0, img.size.height, img.size.width);
//            translateX = 0;
//            translateY = -imgRect.size.width;
//            scaleY = imgRect.size.width/imgRect.size.height;
//            scaleX = imgRect.size.height/imgRect.size.width;
//        }
//            break;
//        case KRotateAngle_180:
//        {
//            rotate = M_PI;
//            imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
//            translateX = -imgRect.size.width;
//            translateY = -imgRect.size.height;
//            scaleY = 1.0;
//            scaleX = 1.0;
//        }
//            break;
//        case KRotateAngle_270:
//        {
//            rotate = 3 * M_PI_2;
//            imgRect = CGRectMake(0, 0, img.size.height, img.size.width);
//            translateX = -imgRect.size.height;
//            translateY = 0;
//            scaleY = imgRect.size.width/imgRect.size.height;
//            scaleX = imgRect.size.height/imgRect.size.width;
//        }
//            break;
//        case KRotateAngle_360:
//        {
//            rotate = 2 * M_PI;
//            imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
//            translateX = 0;
//            translateY = 0;
//            scaleY = 1.0;
//            scaleX = 1.0;
//        }
//            break;
//        default:
//            break;
//    }
//
//    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, 0.0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextTranslateCTM(context, 0.0, -imgRect.size.height);
//
//    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
//    CGContextScaleCTM(context, scaleX, scaleY);
//
//    CGContextDrawImage(context, CGRectMake(0.0, 0.0, imgRect.size.width, imgRect.size.height), img.CGImage);
//    UIImage *rotateIMG = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return rotateIMG;
//}

@end
