//
//  CCSegmentView.h
//  Changcai_iOS
//
//  Created by changcai on 17/7/26.
//  Copyright © 2017年 com.changcai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Size.h"
#import "CCPrgressView.h"
@class CCSegmentView;

typedef enum : NSUInteger {
    CCIndicatorTypeDefault,//默认与按钮长度相同
    CCIndicatorTypeEqualTitle,//与文字长度相同
    CCIndicatorTypeStretch,//滑块拉伸动画
    CCIndicatorTypeExcessive,//滑块过度动画
    CCIndicatorTypeCustom,//自定义文字边缘延伸宽度
    CCIndicatorTypeSpring,//弹性的
    CCIndicatorTypeNone
} CCIndicatorType;//指示器类型枚举

@protocol CCSegmentViewDelegate <NSObject>

@optional

/**
 切换标题
 
 @param titleView FSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (BOOL)segmentTitleView:(CCSegmentView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 将要开始滑动
 
 @param titleView FSSegmentTitleView
 */
- (void)segmentTitleViewWillBeginDragging:(CCSegmentView *)titleView;

/**
 将要停止滑动
 
 @param titleView FSSegmentTitleView
 */
- (void)segmentTitleViewWillEndDragging:(CCSegmentView *)titleView;

@end

@interface CCSegmentView : UIView

@property (nonatomic, weak) id<CCSegmentViewDelegate>delegate;
@property (nonatomic, strong) CCPrgressView * pregressView;
/**
   标题文字间距，默认20
 */
@property (nonatomic, assign) CGFloat itemMargin;
/**
   标题视图左间距，默认20
 */
@property (nonatomic, assign) CGFloat itemLeftMargin;
/**
   滑块的宽度，默认10
 */
@property (nonatomic, assign) CGFloat indicatorWidth;

/**
 滑块的宽度，默认10
 */
@property (nonatomic, assign) CGFloat indicatorHeight;


/**
   当前选中标题索引，默认0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
   标题字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
   标题选中字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleSelectFont;

/**
   标题正常颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
   标题选中颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectColor;

/**
   指示器颜色，默认与titleSelectColor一样,在FSIndicatorTypeNone下无效
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
   在FSIndicatorTypeCustom时可自定义此属性，为指示器一端延伸长度，默认5
 */
@property (nonatomic, assign) CGFloat indicatorExtension;
/**
   标题数组
 */
@property (nonatomic, strong) NSArray *titlesArr;
/**  */
@property (nonatomic, assign) BOOL isCenterDisplay;
/**
 对象方法创建FSSegmentTitleView
 @param frame frame
 @param titlesArr 标题数组
 @param delegate delegate
 @param incatorType 指示器类型
 @return FSSegmentTitleView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<CCSegmentViewDelegate>)delegate indicatorType:(CCIndicatorType)incatorType;

- (void) selectedIndex:(NSUInteger)index;

@end
