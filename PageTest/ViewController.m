//
//  ViewController.m
//  PageTest
//
//  Created by Singer on 15/9/13.
//  Copyright (c) 2015年 Singer. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    NSArray *_controllers;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPageScrollingFlag = NO;
    self.hasAppearedFlag = NO;
    self.currentPageIndex = 1;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    FirstViewController *fvc = [[FirstViewController alloc]init];
    SecondViewController *svc = [[SecondViewController alloc]init];
    _controllers = @[fvc,svc];
    [self.pageViewController setViewControllers:@[svc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect.origin.y+=64;
    self.pageViewController.view.frame = pageViewRect;

//    [self.pageViewController didMoveToParentViewController:self];
//    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

-(void)viewWillAppear:(BOOL)animated {
    if (!self.hasAppearedFlag) {
        [self setupPageViewController];
        self.hasAppearedFlag = YES;
    }
}
-(void)setupPageViewController {
    self.pageViewController = (UIPageViewController*)self.childViewControllers.firstObject;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self syncScrollView];
    
}


-(void)segmentedControlChange:(UISegmentedControl * )segmentedControl{
    if (!self.isPageScrollingFlag) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        //%%% check to see if you're going left -> right or right -> left
        if (segmentedControl.selectedSegmentIndex > tempIndex) {
            
            //%%% scroll through all the objects between the two points
            for (int i = (int)tempIndex+1; i<=segmentedControl.selectedSegmentIndex; i++) {
                [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
        
        //%%% this is the same thing but for going right -> left
        else if (segmentedControl.selectedSegmentIndex < tempIndex) {
            for (int i = (int)tempIndex-1; i >= segmentedControl.selectedSegmentIndex; i--) {
                [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}

-(void)updateCurrentPageIndex:(int)newIndex {
    self.currentPageIndex = newIndex;
}

#pragma mark - UIPageViewController delegate methods
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [_controllers indexOfObject:[pageViewController.viewControllers lastObject]];
        self.segmentedControl.selectedSegmentIndex = self.currentPageIndex;
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [_controllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    return _controllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [_controllers indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [_controllers count]) {
        return nil;
    }
    return _controllers[index];
}

-(void)syncScrollView {
    for (UIView* view in self.pageViewController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
//            self.pageScrollView.scrollEnabled = NO;
        }
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = NO;
}



@end
