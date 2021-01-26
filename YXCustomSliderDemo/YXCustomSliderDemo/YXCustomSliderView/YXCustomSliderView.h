//
//  YXCustomSliderView.h
//  YXCustomSliderDemo
//
//  Created by ios on 2021/1/26.
//

#import <UIKit/UIKit.h>
#import "UIColor+YXCategory.h"
#import "YXCustomSliderPointView.h"

NS_ASSUME_NONNULL_BEGIN

#define kCount 9
/** 背景视图宽 */
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
/** 常规、选中背景视图宽 */
#define kSliderBgVWidth (kScreenWidth - 25 *2)
/** 常规、选中背景视图高 */
#define kSliderBgVHeight 3
/** 常规、选中背景视图X */
#define kSliderX fabs(kScreenWidth - kSliderBgVWidth) /2

typedef void(^YXCustomSliderVBlock)(CGFloat minValue, CGFloat maxValue);

@interface YXCustomSliderView : UIView

@property (nonatomic, assign, readonly) CGFloat minValue;
@property (nonatomic, assign, readonly) CGFloat maxValue;

@property (nonatomic, copy) YXCustomSliderVBlock yxCustomSliderVBlock;

@end

NS_ASSUME_NONNULL_END
