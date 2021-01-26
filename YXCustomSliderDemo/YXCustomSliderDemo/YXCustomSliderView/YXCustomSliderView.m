//
//  YXCustomSliderView.m
//  YXCustomSliderDemo
//
//  Created by ios on 2021/1/26.
//

#import "YXCustomSliderView.h"

@interface YXCustomSliderView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *defualtBgV; //常规背景视图
@property (nonatomic, strong) UIView *selectedBgV; //选中背景视图
@property (nonatomic, strong) UIImageView *leftSliderImgV; //左滑块
@property (nonatomic, strong) UIImageView *rightSliderImgV; //右滑块
@property (nonatomic, assign) CGFloat leftSliderValue; //左滑块值
@property (nonatomic, assign) CGFloat rightSliderValue; //右滑块值
@property (nonatomic, assign) CGFloat priceMax; //最大移动距离
@property (nonatomic, assign) CGFloat priceMin; //最小移动距离
@property (nonatomic, assign) CGFloat partWidth; //间距

@end

@implementation YXCustomSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initDataSource];
        [self initView];
    }
    return self;
}

#pragma mark - progress
#pragma mark - 左滑块滑动
- (void)progressLeftPanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture translationInView:_leftSliderImgV];
    
    CGFloat x = _leftSliderImgV.center.x + point.x;
    if (x > _priceMax) {
        x = _priceMax;
    }
    else if (x < kSliderX) {
        x = kSliderX;
    }
    
    _leftSliderValue = [self coordinatesToNumberMethodByX:ceilf(x)];
    _leftSliderImgV.center = CGPointMake(ceilf(x), _leftSliderImgV.center.y);
    
    if (_rightSliderValue - _leftSliderValue <= 10) {
        _rightSliderValue = _leftSliderValue + 10;
        _rightSliderImgV.center = CGPointMake([self numberToCoordinatesMethodByValue:_rightSliderValue], _rightSliderImgV.center.y);
    }
    
    [gesture setTranslation:CGPointZero inView:self];
    [self updateData];
    
    if (gesture.state == UIGestureRecognizerStateEnded && self.yxCustomSliderVBlock) {
        self.yxCustomSliderVBlock(self.minValue, self.maxValue);
    }
}

#pragma mark - 右滑块滑动
- (void)progressRightPanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture translationInView:_rightSliderImgV];
    CGFloat x = _rightSliderImgV.center.x + point.x;
    
    if (x > kSliderX + kSliderBgVWidth) {
        x = kSliderX + kSliderBgVWidth;
    }
    else if (x < _priceMin + kSliderX) {
        x = _priceMin + kSliderX;
    }
    
    _rightSliderValue = [self coordinatesToNumberMethodByX:ceilf(x)];
    _rightSliderImgV.center = CGPointMake(ceilf(x), _rightSliderImgV.center.y);
    
    if (_rightSliderValue - _leftSliderValue <= 10) {
        _leftSliderValue = _rightSliderValue - 10;
        _leftSliderImgV.center = CGPointMake([self numberToCoordinatesMethodByValue:_leftSliderValue], _leftSliderImgV.center.y);
    }
    
    [gesture setTranslation:CGPointZero inView:self];
    [self updateData];
    
    if (gesture.state == UIGestureRecognizerStateEnded && self.yxCustomSliderVBlock) {
        self.yxCustomSliderVBlock(self.minValue, self.maxValue);
    }
}

#pragma mark - 更新数据显示
- (void)updateData {
    
    NSString *value = @"价格不限";
    if (_rightSliderValue > 100 && _leftSliderValue != 0) {
        value = [NSString stringWithFormat:@"%.0f以上", _leftSliderValue];
    }
    else if (_rightSliderValue <= 100) {
        value = [NSString stringWithFormat:@"%.0f~%.0f", _leftSliderValue, _rightSliderValue];
    }
    _titleLab.text = value;
    
    CGRect progressRect = CGRectMake(_leftSliderImgV.center.x, _selectedBgV.frame.origin.y, _rightSliderImgV.center.x - _leftSliderImgV.center.x, _selectedBgV.frame.size.height);
    _selectedBgV.frame = progressRect;
}

#pragma mark - 坐标->数字
- (CGFloat)coordinatesToNumberMethodByX:(CGFloat)x {
    
    CGFloat price = 0.f;
    CGFloat realX = x - kSliderX;
    if (x < kSliderX + (_priceMin *3)) { //0~30
        price = realX /(_priceMin *3) *30;
    }
    else if (x < kSliderX + (_priceMin *5)) { //30~70
        price = (realX - _priceMin *3) /(_priceMin *2) *40 + 30;
    }
    else if (x < kSliderX + (_priceMin *8)) { //70~100
        price = (realX - _priceMin *5) /(_priceMin *3) *30 +70;
    }
    else { //100+
        price = (realX - _priceMin *8) /_priceMin *10 +100;
    }
    
    return price;
}

#pragma mark - 数字->坐标
- (CGFloat)numberToCoordinatesMethodByValue:(CGFloat)value {

    CGFloat x = 0.f;
    if (value >= 0 && value < 30) { //0~30
        x = value /30 *(_priceMin *3);
    }
    else if (value >= 30 && value < 70) { //30~70
        x = (value - 30) /40 *(_priceMin *2) + _priceMin *3;
    }
    else if (value >= 70 && value < 100) { //70~100
        x = (value - 70) /30 *(_priceMin *3) + _priceMin *5;
    }
    else if (value >= 100) {
        x = (value - 100) / 10 *_priceMin + _priceMin *8;
    }
    
    return x + kSliderX;
}

#pragma mark - 初始化数据
- (void)initDataSource {
    
    _leftSliderValue = 0;
    _rightSliderValue = 100;
}

#pragma mark - 初始化视图
- (void)initView {
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 12)];
    _titleLab.textColor = [UIColor yxColorByHexString:@"#000000"];
    _titleLab.font = [UIFont systemFontOfSize:12];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = @"价格不限";
    [self addSubview:_titleLab];
    
    _defualtBgV = [[UIView alloc] initWithFrame:CGRectMake(kSliderX, CGRectGetMaxY(_titleLab.frame) + 40, kSliderBgVWidth, kSliderBgVHeight)];
    _defualtBgV.backgroundColor = [UIColor yxColorByHexString:@"#E9E9E9"];
    [self addSubview:_defualtBgV];
    
    _selectedBgV = [[UIView alloc] initWithFrame:_defualtBgV.frame];
    _selectedBgV.backgroundColor = [UIColor yxColorByHexString:@"#11D7D0"];
    [self addSubview:_selectedBgV];
    
    CGFloat sliderWidth = 20.f;
    CGFloat sliderHeight = 30.f;
    
    //左滑块
    CGFloat leftSliderX = kSliderX - sliderWidth *0.5;
    CGFloat leftSliderY = CGRectGetMinY(_defualtBgV.frame) - 2;
    _leftSliderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(leftSliderX, leftSliderY, sliderWidth, sliderHeight)];
    [_leftSliderImgV setImage:[UIImage imageNamed:@"YXProjPriceSliderImg"]];
    [self addSubview:_leftSliderImgV];
    
    //右滑块
    CGFloat rightSliderX = CGRectGetMaxX(_defualtBgV.frame) - sliderWidth *0.5;
    CGFloat rightSliderY = leftSliderY;
    _rightSliderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(rightSliderX, rightSliderY, sliderWidth, sliderHeight)];
    [_rightSliderImgV setImage:[UIImage imageNamed:@"YXProjPriceSliderImg"]];
    [self addSubview:_rightSliderImgV];
    
    //左滑块添加滑动手势
    UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(progressLeftPanGesture:)];
    [leftPanGesture setMinimumNumberOfTouches:1];
    [leftPanGesture setMaximumNumberOfTouches:1];
    [_leftSliderImgV setUserInteractionEnabled:YES];
    [_leftSliderImgV addGestureRecognizer:leftPanGesture];
    
    //右滑块添加滑动手势
    UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(progressRightPanGesture:)];
    [_rightSliderImgV setUserInteractionEnabled:YES];
    [_rightSliderImgV addGestureRecognizer:rightPanGesture];
    
    _partWidth = kSliderBgVWidth /kCount; //分段起点x
    _priceMin = _partWidth;
    _priceMax = _partWidth *(kCount - 1) + kSliderX;
    for (NSInteger i = 0; i < kCount + 1; i ++) {
        YXCustomSliderPointView *showView = [[[NSBundle mainBundle] loadNibNamed:[YXCustomSliderPointView.class description] owner:self options:nil] lastObject];
        showView.bounds = CGRectMake(0, 0, 21, 18);
        showView.center = CGPointMake(_partWidth *i, -showView.bounds.size.height /2 - 2);
        if (i == kCount) { //10~无限
            showView.titleLab.text = [NSString stringWithFormat:@"%@", @"不限"];
        }
        else if (i == 4) { //5
            showView.titleLab.text = [NSString stringWithFormat:@"%@", @(5)];
        }
        else if (i == 5) { //7
            showView.titleLab.text = [NSString stringWithFormat:@"%@", @(7)];
        }
        else if (i > 5) { //8、9、10
            showView.titleLab.text = [NSString stringWithFormat:@"%@", @(i + 2)];
        }
        else { //1、2、3、4
            showView.titleLab.text = [NSString stringWithFormat:@"%@", @(i)];
        }
        
        self.defualtBgV.clipsToBounds = NO;
        [self.defualtBgV addSubview:showView];
    }
}

- (CGFloat)minValue {
    
    return _leftSliderValue;
}

- (CGFloat)maxValue {
    
    return _rightSliderValue;
}

@end
