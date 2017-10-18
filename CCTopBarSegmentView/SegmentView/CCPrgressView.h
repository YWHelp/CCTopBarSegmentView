//
//  CCPrgressView.h
//  Changcai_iOS
//
//  Created by changcai on 2017/10/17.
//  Copyright © 2017年 com.changcai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPrgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSMutableArray * itemFrames;
@property (nonatomic, assign) CGColorRef color;
@property (nonatomic, assign) BOOL isNaugty;
@end
