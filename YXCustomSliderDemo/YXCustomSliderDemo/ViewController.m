//
//  ViewController.m
//  YXCustomSliderDemo
//
//  Created by ios on 2021/1/26.
//

#import "ViewController.h"
#import "YXCustomSliderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YXCustomSliderView *sliderView = [[YXCustomSliderView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 88)];
    [self.view addSubview:sliderView];
}


@end
