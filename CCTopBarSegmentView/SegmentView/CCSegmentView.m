//
//  CCSegmentView.m
//  Changcai_iOS
//
//  Created by changcai on 17/7/26.
//  Copyright © 2017年 com.changcai.cn. All rights reserved.
//

#import "CCSegmentView.h"


@interface CCSegmentView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtnArr;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, assign) CCIndicatorType indicatorType;
@property (nonatomic, strong) NSMutableArray * pregressFrames;
@end

@implementation CCSegmentView
{
    BOOL _isSelected;
    CGFloat _sliderOffsetX;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<CCSegmentViewDelegate>)delegate indicatorType:(CCIndicatorType)incatorType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithProperty];
        _titlesArr = titlesArr;
        _delegate = delegate;
        _indicatorType = incatorType;
    }
    return self;
}
//初始化默认属性值
- (void)initWithProperty
{
    self.itemMargin = 20;
    self.itemLeftMargin = 20;
    self.selectIndex = 0;
    self.indicatorWidth = 10;
    self.indicatorHeight = 4;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:15];
    self.indicatorColor = [UIColor clearColor];
    self.indicatorExtension = 5.f;
    self.titleSelectFont = self.titleFont;
    self.isCenterDisplay = NO;
}
//重新布局frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.pregressFrames.count > 0){
        [self.pregressFrames removeAllObjects];
    }
    self.scrollView.frame = self.bounds;
    
    if (self.itemBtnArr.count == 0) {
        return;
    }
    CGFloat totalBtnWidth = 0.0;
    UIFont *titleFont = _titleFont;
    if (_titleFont != _titleSelectFont) {
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [CCSegmentView getWidthWithString:self.titlesArr[idx] font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }else{
        for (NSString *title in self.titlesArr) {
            CGFloat itemBtnWidth = [CCSegmentView getWidthWithString:title font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    if (totalBtnWidth <= CGRectGetWidth(self.bounds) && _isCenterDisplay == NO) {//不能滑动
        //让按钮栏居中
        __block CGFloat  itemBtnLeftMargin = (CGRectGetWidth(self.bounds) - totalBtnWidth + self.itemMargin)*0.5;
        CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
        [self.itemBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat itemBtnWidth = [CCSegmentView getWidthWithString:self.titlesArr[idx] font:_titleFont];
             obj.frame = CGRectMake(itemBtnLeftMargin, 0, itemBtnWidth, itemBtnHeight);
             itemBtnLeftMargin += (itemBtnWidth + self.itemMargin);
             [self.pregressFrames addObject:[NSValue valueWithCGRect: CGRectMake(obj.centerX-10,obj.height - self.indicatorHeight, self.indicatorWidth, self.indicatorHeight)]];
        }];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
    }else{//超出屏幕 可以滑动
        CGFloat currentX = self.itemLeftMargin;
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [CCSegmentView getWidthWithString:self.titlesArr[idx] font:titleFont];
            CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
            btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
            currentX += (itemBtnWidth + self.itemMargin);
            [self.pregressFrames addObject:[NSValue valueWithCGRect:CGRectMake(btn.centerX - self.indicatorWidth*0.5,btn.height - self.indicatorHeight, self.indicatorWidth, self.indicatorHeight)]];
        }
        self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
    }
    if(_indicatorType == CCIndicatorTypeSpring){
        if(_pregressView == nil){
            //添加滚动条
            _pregressView = [[CCPrgressView alloc] initWithFrame:CGRectMake(0, self.height - self.indicatorHeight,  self.scrollView.contentSize.width,self.indicatorHeight)];
            _pregressView.itemFrames = self.pregressFrames;
            _pregressView.backgroundColor = [UIColor clearColor];
            [self.scrollView  addSubview:_pregressView];
        }
         [self scrollSelectBtnCenter:YES];
    }else{
         [self moveIndicatorView:YES];
    }
}

- (void)moveIndicatorView:(BOOL)animated
{
    UIFont *titleFont = _titleFont;
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    titleFont = selectBtn.isSelected?_titleSelectFont:_titleFont;
    CGFloat indicatorWidth = [CCSegmentView getWidthWithString:self.titlesArr[self.selectIndex] font:titleFont];
    [UIView animateWithDuration:(_isSelected?0.35:0.0) animations:^{
        switch (_indicatorType) {
            case CCIndicatorTypeDefault:
                self.indicatorView.frame = CGRectMake(selectBtn.frame.origin.x , CGRectGetHeight(self.scrollView.bounds) - 2, CGRectGetWidth(selectBtn.bounds), 2);
                break;
            case CCIndicatorTypeEqualTitle:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, 2);
                break;
            case CCIndicatorTypeStretch:
            {
                if(_isSelected == YES){
                        if(selectBtn.x < _sliderOffsetX){
                            [UIView animateWithDuration:0.2 //动画持续时间
                                                  delay:0.0 //动画延迟执行的时间
                                                options:UIViewAnimationOptionCurveEaseInOut //动画的过渡效果
                                             animations:^{
                                
                                self.indicatorView.frame = CGRectMake(selectBtn.center.x-self.indicatorWidth*0.5 , CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight, (self.indicatorView.center.x -selectBtn.center.x) + self.indicatorWidth, self.indicatorHeight);
                                
                            } completion:^(BOOL finished) {
                                
                                self.indicatorView.frame = CGRectMake(selectBtn.center.x-self.indicatorWidth*0.5, CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight,self.indicatorWidth,self.indicatorHeight);
                            }];
                            
                        }else if(selectBtn.x > _sliderOffsetX){
                            
                            [UIView animateWithDuration:0.2 //动画持续时间
                                                  delay:0.0 //动画延迟执行的时间
                                                options:UIViewAnimationOptionCurveEaseInOut //动画的过渡效果
                                             animations:^{
                                                 self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x, CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight, (selectBtn.center.x - self.indicatorView.center.x) + self.indicatorWidth, self.indicatorHeight);
                            } completion:^(BOOL finished) {
                                
                                self.indicatorView.frame = CGRectMake(selectBtn.center.x-self.indicatorWidth*0.5, CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight,self.indicatorWidth,self.indicatorHeight);
                            }];
                            
                        }else{
                            
                            
                        }
                        //记录当前的位置
                        _sliderOffsetX = selectBtn.x;
                }else{
                    //self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight);
                    self.indicatorView.frame = CGRectMake(selectBtn.center.x-self.indicatorWidth*0.5, CGRectGetHeight(self.scrollView.bounds) - self.indicatorHeight,self.indicatorWidth,self.indicatorHeight);
                }
            }
                break;
            case CCIndicatorTypeExcessive:
            {
                
                UIImage *originImage = [UIImage imageNamed:@"bg_nav_fuc"];
                self.indicatorView.center = CGPointMake(selectBtn.center.x, selectBtn.center.y);
                if(indicatorWidth > 30){
                    UIImage *resizableImage = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(originImage.size.height*0.5, originImage.size.width*0.5, originImage.size.height*0.5, originImage.size.width*0.5) resizingMode:UIImageResizingModeStretch];
                    self.indicatorView.image = resizableImage;
                    self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth+36, 47);
                }else{
                    self.indicatorView.image = originImage;
                    self.indicatorView.bounds = CGRectMake(0, 0, 66, 47);
                }
            }
               break;
            case CCIndicatorTypeCustom:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth + _indicatorExtension*2, 2);
                break;
            case CCIndicatorTypeNone:
                self.indicatorView.frame = CGRectZero;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        
        [self scrollSelectBtnCenter:animated];
        
    }];
}

- (void)scrollSelectBtnCenter:(BOOL)animated
{
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    CGRect centerRect = CGRectMake(selectBtn.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}

#pragma mark --LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray<UIButton *>*)itemBtnArr
{
    if (!_itemBtnArr) {
        _itemBtnArr = [[NSMutableArray alloc]init];
    }
    return _itemBtnArr;
}

- (UIImageView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --Setter

- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self.itemBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtnArr = nil;
    for (NSString *title in titlesArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtnArr.count + 666;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = _titleFont;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.itemBtnArr.count == self.selectIndex) {
            btn.selected = YES;
            btn.titleLabel.font = _titleSelectFont;
        }
        [self.itemBtnArr addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void) setItemLeftMargin:(CGFloat)itemLeftMargin
{
    _itemLeftMargin = itemLeftMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex||selectIndex < 0||selectIndex > self.itemBtnArr.count - 1) {
        return;
    }
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = _titleFont;
    _selectIndex = selectIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = _titleSelectFont;
    //[self moveIndicatorView:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont
{
    if (_titleFont == titleSelectFont) {
        _titleSelectFont = _titleFont;
        return;
    }
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = btn.isSelected?titleSelectFont:_titleFont;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}
- (void)setIndicatorWidth:(CGFloat)indicatorWidth
{
    _indicatorWidth = indicatorWidth;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)setIndicatorExtension:(CGFloat)indicatorExtension
{
    _indicatorExtension = indicatorExtension;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (NSMutableArray *)pregressFrames
{
    if (!_pregressFrames) {
        _pregressFrames = [NSMutableArray array];
    }
    return _pregressFrames;
}


#pragma mark --Btn

- (void) selectedIndex:(NSUInteger)index
{
    if (index == self.selectIndex) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(segmentTitleView:startIndex:endIndex:)]) {
         BOOL isCanMove = [self.delegate segmentTitleView:self startIndex:self.selectIndex endIndex:index];
        if(isCanMove){
            _isSelected = YES;
            self.selectIndex = index;
        }
    }
}
- (void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 666;
    [self selectedIndex:index];
}

#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(segmentTitleViewWillBeginDragging:)]) {
        [self.delegate segmentTitleViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(segmentTitleViewWillEndDragging:)]) {
        [self.delegate segmentTitleViewWillEndDragging:self];
    }
}
#pragma mark Private
/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
/**
 随机色
 
 @return 调试用
 */
+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


@end

