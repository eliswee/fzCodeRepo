//
//  FZRACDemoController.m
//  FZCodeRepo
//
//  Created by zfz on 2018/9/5.
//  Copyright © 2018年 zhfeze. All rights reserved.
//

#import "FZRACDemoController.h"
#import <ReactiveObjC.h>

@interface FZRACDemoController ()
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) UITextField *txF1;
@property (nonatomic, strong) UITextField *txF2;
@end

@implementation FZRACDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /** 将方法封装为信号量 */
    
    //    RACSignal *vS = [self rac_signalForSelector:@selector(viewDidAppear:)];
    //
    //    [vS subscribeNext:^(id  _Nullable x) { // 订阅/调用
    //        NSLog(@"%@", x);
    //        NSLog(@"%s", __func__);
    //    }];
    //
    //    [vS subscribeError:^(NSError * _Nullable error) {
    //
    //    } completed:^{
    //
    //    }];
    //
    //    [vS subscribeCompleted:^{
    //
    //    }];
    
    
    /** target_action-button */
    
    //    [self.but setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    //
    //        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //            NSLog(@"click");
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [subscriber sendNext:[[NSDate date] description]];
    //                NSLog(@"---");
    //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                    NSLog(@"complish");
    //                    [subscriber sendCompleted]; // 调用sendCompleted 之前按钮是不可点击的！！！
    //                });
    //            });
    //            return [RACDisposable disposableWithBlock:^{
    //                NSLog(@"dispose");
    //            }];
    //        }];
    //    }]];
    //
    //    [[self.but.rac_command executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
    //        // x的是信号量
    //        NSLog(@"1x:%@", x);
    //        [x subscribeNext:^(id  _Nullable x) {
    //            // 信号量的返回
    //            NSLog(@"2x:%@", x);
    //        }];
    //    }];
    
    /** target_action-textField */
    
    // 1.监听signal
    [self.txF1.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
    }];
    
    // 2.map映射
    //    RACSignal *mapS = [self.txF1.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    //        // value 是 NSString
    //        return @(value.length > 6);
    //    }];
    //
    //    self.but.rac_command = [[RACCommand alloc] initWithEnabled:mapS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    //
    //        return [RACSignal empty];
    //
    ////        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    ////
    ////            return [RACDisposable disposableWithBlock:^{
    ////
    ////            }];
    ////        }];
    //    }];
    
    // 3.合并+map映射
    
    RACSignal *comb = [[RACSignal combineLatest:@[self.txF1.rac_textSignal, self.txF2.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        NSLog(@"=-=-%@", value);
        return @([value[0] length]>0 && [value[1] length]>6);
    }];
    
    self.but.rac_command = [[RACCommand alloc] initWithEnabled:comb signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIButton *)but {
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(100, 100, 100, 100);
        [_but setTitle:@"haha" forState:UIControlStateNormal];
        [self.view addSubview:_but];
    }
    return _but;
}

- (UITextField *)txF1 {
    if (!_txF1) {
        _txF1 = [[UITextField alloc] init];
        _txF1.borderStyle = UITextBorderStyleRoundedRect;
        _txF1.frame = CGRectMake(200, 300, 100, 50);
        [self.view addSubview:_txF1];
    }
    return _txF1;
}

- (UITextField *)txF2 {
    if (!_txF2) {
        _txF2 = [[UITextField alloc] init];
        _txF2.borderStyle = UITextBorderStyleRoundedRect;
        _txF2.frame = CGRectMake(200, 450, 100, 50);
        [self.view addSubview:_txF2];
    }
    return _txF2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
