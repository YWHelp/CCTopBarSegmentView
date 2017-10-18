//
//  CCPageContentView.h
//  Changcai_iOS
//
//  Created by changcai on 2017/10/17.
//  Copyright © 2017年 com.changcai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Size.h"
@class CCPageContentView;

@protocol CCPageContentViewDelegare <NSObject>

- (void)pageContentView:(CCPageContentView *)pageContentView   contentOffsetX:(CGFloat)contentOffsetX  progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

- (void)pageContentView:(CCPageContentView *)pageContentView  scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@interface CCPageContentView : UIView
/**
 *  对象方法创建 SGPageContentView
 *
 *  @param frame     frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 SGPageContentView
 *
 *  @param frame     frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** delegatePageContentView */
@property (nonatomic, weak) id<CCPageContentViewDelegare> delegatePageContentView;
/** 是否需要滚动 SGPageContentView，默认为 YES；设为 NO 时，不用设置 SGPageContentView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 给外界提供的方法，获取 SGPageTitleView 选中按钮的下标, 必须实现 */
- (void)setPageCententViewCurrentIndex:(NSInteger)currentIndex;

@end
