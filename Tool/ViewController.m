//
//  ViewController.m
//  Tool
//
//  Created by walen on 2019/4/1.
//  Copyright © 2019 walen. All rights reserved.
//

#import "ViewController.h"
#import "MaskView.h"

@interface ViewController ()

@property (nonatomic,strong)MaskView *mask;
@property (nonatomic,strong)UIImageView *showIMG;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mask = [[MaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.mask];
    [self.view insertSubview:self.mask atIndex:0];
    
    [self.view addSubview:self.showIMG];
}


- (UIImageView *)showIMG
{
    if (!_showIMG) {
        _showIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _showIMG.layer.borderColor = [UIColor redColor].CGColor;
        _showIMG.layer.borderWidth = 2.0;
        _showIMG.backgroundColor = [UIColor whiteColor];
    }
    return _showIMG;
}

- (IBAction)rotateAction:(id)sender {
    NSLog(@"%s",__func__);
    [self.mask rotateImage];
}
- (IBAction)cancelAction:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)resetAction:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)finishAction:(id)sender {
    NSLog(@"%s",__func__);
    [self.showIMG setImage:[self.mask clipImage]];
}

@end
