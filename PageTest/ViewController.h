//
//  ViewController.h
//  PageTest
//
//  Created by Singer on 15/9/13.
//  Copyright (c) 2015年 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic,strong) UIPageViewController *pageViewController;
@property(nonatomic,assign) BOOL isPageScrollingFlag;
@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic,assign) NSUInteger currentPageIndex;
@property(nonatomic,strong) UIScrollView *pageScrollView;
@property(nonatomic,assign) BOOL hasAppearedFlag;
@end

