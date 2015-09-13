//
//  FirstViewController.m
//  PageTest
//
//  Created by Singer on 15/9/13.
//  Copyright (c) 2015年 Singer. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"

@interface FirstViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    CGFloat _lastPosition;
    CGRect _viewDefaultFrame;
    CGRect _tabbarDefaultFrame;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64-49);
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _viewDefaultFrame = frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (CGRectIsEmpty(_tabbarDefaultFrame) ) {
        ViewController *vc = (ViewController *)self.parentViewController.parentViewController;
        _tabbarDefaultFrame = vc.tabBarController.tabBar.frame;
    }
    _tableView.frame = _viewDefaultFrame;
    self.parentViewController.parentViewController.tabBarController.tabBar.frame = _tabbarDefaultFrame;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _tableView.frame = _viewDefaultFrame;
    self.parentViewController.parentViewController.tabBarController.tabBar.frame = _tabbarDefaultFrame;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

#pragma mark 每当有一个cell进入屏幕视野范围内就会被调用 返回当前这行显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用static 只会初始化一次
    static NSString *ID = @"UITableViewCell";
    //拿到一个标示符先去缓存池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //如果缓存池中没有，才需要传入一个标识创建新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    //覆盖数据
    cell.textLabel.text = @"first....";
    return cell;
}

#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//    
//    int currentPostion = scrollView.contentOffset.y;
//    
//    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
//        
//        _lastPosition = currentPostion;
//        
//        _tableView.frame = CGRectMake(CGRectGetMinX(_viewDefaultFrame), CGRectGetMinY(_viewDefaultFrame), CGRectGetWidth(_viewDefaultFrame), CGRectGetHeight(_viewDefaultFrame)+49);
//        [UIView animateWithDuration:0.25 animations:^{
//            self.parentViewController.parentViewController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetMinY(_tabbarDefaultFrame)+60, CGRectGetWidth(_tabbarDefaultFrame), CGRectGetHeight(_tabbarDefaultFrame));
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        //        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//    }
//    
//    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
//        
//    {
//        
//        _lastPosition = currentPostion;
//        
//        _tableView.frame = _viewDefaultFrame;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.parentViewController.parentViewController.tabBarController.tabBar.frame = _tabbarDefaultFrame;
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        
//    }
//}
@end
