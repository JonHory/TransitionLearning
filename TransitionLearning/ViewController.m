//
//  ViewController.m
//  TransitionLearning
//
//  Created by rhcf_wujh on 16/9/28.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "ViewController.h"
#import "SecondVC.h"

#import "BossVC.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

@property (nonatomic ,weak) UITableView * tableView;

@property (nonatomic ,assign) NSInteger lastIndexRow;

@property (nonatomic ,weak) UIImageView * screenshot;

@end

#define SCREEN [UIScreen mainScreen].bounds.size

@implementation ViewController

- (UIImageView *)screenshot{
    if (!_screenshot) {
        UIImageView * view = [[UIImageView alloc]init];
        [self.view addSubview:view];
        _screenshot = view;
    }
    return _screenshot;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        
        _tableView = tableView;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fisrt VC";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"NO.%zi",indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"BOSS直聘动画";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"图片动画";
    }
    cell.imageView.image = [UIImage imageNamed:@"appii"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [self tranToBoss];
    }
    else if (indexPath.row == 1) {
        [self presentVC:cell.imageView type:nil];
    }else {
        [self presentVC:cell.imageView type:@"vv"];
    }

//    switch (indexPath.row) {
//        case 0:
//            [self presentVC:cell.imageView];
//            break;
//            
//        default:
//            break;
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%zi",self.lastIndexRow);
    if (self.lastIndexRow < indexPath.row) {
        NSLog(@"向下");
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, 0, 0, 0, 1);//这里应该是角度
        transform = CATransform3DScale(transform, 1.2, 1.5, 0);//这个状态是放大的状态，之后变回原样，应该是由大变小
        cell.layer.transform = transform;
        cell.layer.opacity = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        }];
    }
    else if (self.lastIndexRow > indexPath.row){
        NSLog(@"向上");
    }
    
    self.lastIndexRow = indexPath.row;
}


#pragma mark - Push
- (void)tranToBoss{
    self.screenshot.image = [self screenImageWithSize:self.view.bounds.size];
    self.screenshot.frame = self.view.bounds;
    self.tableView.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    BossVC * vc = [[BossVC alloc]init];
    
    __weak __typeof(&*self)weakSelf = self;
    vc.block = ^(){
        [weakSelf.screenshot removeFromSuperview];
        weakSelf.tableView.hidden = NO;
        weakSelf.tabBarController.tabBar.hidden = NO;
    };
    
    [self presentViewController:vc animated:NO completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.screenshot.bounds = CGRectMake(50, 50, SCREEN.width - 100, SCREEN.height - 100);
    } completion:^(BOOL finished) {
        [vc changeBigView];
    }];
}

- (void)presentVC:(UIImageView *)iv type:(NSString *)type{
    SecondVC * vc = [[SecondVC alloc]initWithIV:iv];
//    vc.transitioningDelegate = self;
    vc.type = type;
    [self presentViewController:vc animated:NO completion:nil];
    //[self.navigationController pushViewController:vc animated:NO];
}



#pragma mark - Private
-(UIImage *)screenImageWithSize:(CGSize )imgSize{
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate; //获取app的appdelegate，便于取到当前的window用来截屏
    [app.window.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return [TransFromAnimation transfromWithAnimationType:YJPPresentAnimationPresent];
//}
//
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [TransFromAnimation transfromWithAnimationType:YJPPresentAnimationDismiss];
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
