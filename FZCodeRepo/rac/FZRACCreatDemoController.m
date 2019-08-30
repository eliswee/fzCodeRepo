//
//  FZRACCreatDemoController.m
//  FZCodeRepo
//
//  Created by zfz on 2018/9/11.
//  Copyright © 2018年 zhfeze. All rights reserved.
//

#import "FZRACCreatDemoController.h"
#import <ReactiveObjC.h>

@interface FZRACCreatDemoController () <CLLocationManagerDelegate>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation FZRACCreatDemoController
// http://app1.tv.cmvideo.cn:9001/api/minivideo/min/findMusicByContendId?contentId="54321"


- (instancetype)init {
    if (self = [super init]) {
//        [self demo1];
//        [self demo2];
//        [self demo3];
//        [self demo4];
//        self.name = @"33211";
        [self demo5];
    }
    return self;
}

- (void)demo5 {
    [[[[[self authorizedSignal] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value){ // then 不可以 要用flattenMap
        return [[[[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return value[1];
        }] merge:[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)]] map:^id _Nullable(id  _Nullable value) {
            return value; //[RACSignal error:value[1]];
        }] take:1] initially:^{
            [self.manager startUpdatingLocation];
        }] finally:^{
            [self.manager stopUpdatingLocation];
        }];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) { // value 位置数组
        CLLocation *location = [value firstObject];
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [self.geoCoder reverseGeocodeLocation:self.manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    [subscriber sendError:error];
                    NSLog(@"error===%@", error);
                } else {
                    NSLog(@"dibao=%@", placemarks);
                    [subscriber sendNext:[placemarks firstObject]];
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"+++++++%@", [x addressDictionary][@"Name"]);
    }];
}

- (RACSignal *)authorizedSignal {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) { // 未授权
        [self.manager requestAlwaysAuthorization];
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return @([value[1] integerValue] == kCLAuthorizationStatusAuthorizedAlways);
        }];
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)];
}

- (void)demo4 {
    RACSignal *kvoSignal = RACObserve(self, name);
    [kvoSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"=-=-%@", x);
    }];
    
    // 常用
//    RAC() = RACObserve(<#TARGET#>, <#KEYPATH#>)
}

- (void)demo3 {
    
    RACSequence *s1 = [@[@1,@2,@3] rac_sequence];
    RACSequence *s2 = [@[@1,@3,@9] rac_sequence];
    
//    RACSequence *s3 = [[@[s1, s2] rac_sequence] flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
//        return [value filter:^BOOL(id  _Nullable value) {
//            return [value integerValue] % 3 == 0;
//        }];
//    }];
    
    RACSequence *s3 = [[@[s1, s2] rac_sequence] flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
        NSLog(@"=======%@", value);
        return value;
    }];
    
    NSLog(@"%@", [s3 array]);
}

- (void)demo2 {
    /** push-drive       pull-drive */
    /** 拉驱动              推驱动 */
    // 拉驱动：当有人订阅才会执行信号量的代码
    __block int a = 10;
    RACSignal *tempSignal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        a += 5;
        
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLast]; // replayLast: 记录上次返回的值 不会再次执行
    
    [tempSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1st-%@", x);
    }];
    
    [tempSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2nd-%@", x);
    }];
    
    // side effect 副作用
    // 每次订阅都会执行一次信号量的代码   用 replayLast 解决
    
    // RACSequence 推驱动  在初始化的时候内容就已经确定
    //        RACSequence => RACStream
    
    // 互相转化：
    RACSequence *seq = [tempSignal sequence];
    __unused RACSignal *segg = [seq signal];
    
    // RACSequence 相当于 NSArray  是RAC中的一个数组容器 (懒加载的)
    NSArray *arr = @[@3, @4, @5, @6, @7];
    RACSequence *seqq = [arr rac_sequence];
    __unused NSArray *arrr = [seqq array];
    
    
    // map, filter, flattenMap, concat...
    
    // map:
    //        RACSequence *newSeqq = [seqq map:^id _Nullable(id  _Nullable value) {
    //            return @([value intValue] * 3);
    //        }];
    //        NSLog(@"seqq:%@", [newSeqq array]);
    
    // filter
    //        RACSequence *newSeqq = [seqq filter:^BOOL(id  _Nullable value) {
    //            if ([value intValue] % 2 == 1) return YES;
    //            return NO;
    //        }];
    //        NSLog(@"%@", [newSeqq array]);
    
    // flattenMap 先执行map操作，再执行flatten操作
    // 整平操作：
    // 数组1：[1, 2]
    // 数组2：[3, 4]
    // 组合之后: [[1, 2], [3, 4]]
    // 整平之后： [1, 2, 3, 4]
    
    // concat
    // [1, 2] [3, 4] concat : [1, 2, 3, 4]
    
    RACSignal *s11;
    RACSignal *s22;
    RACSignal *s33;
    [[s11 concat:s22] concat:s33]; // s11执行完返回值之后执行s22...
    // concat 和 then 的区别： concat会返回所有信号的值，  then 只返回最后一个信号的值
    
}

- (void)demo1 {
    NSString *urlStr = @"http://app1.tv.cmvideo.cn:9001/api/minivideo/min/findMusicByContendId?contentId=54321";
    
    //        [[self signalFromURLStr:urlStr] subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"----------------%@", x);
    //        }];
    
    [[self signalFromURLStr:urlStr] subscribeNext:^(id  _Nullable x) {
        NSLog(@"----------------%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"----------------%@", error);
    } completed:^{
        NSLog(@"----------------");
    }];
    
    RACSignal *s1 = [self signalFromURLStr:urlStr];
    RACSignal *s2 = [self signalFromURLStr:urlStr];
    RACSignal *s3 = [self signalFromURLStr:urlStr];
    
    __unused RACSignal *sig = [[s1 merge:s2] merge:s3]; // 并行执行 任一返回就执行sendNext
    
    __unused RACSignal *fianlSig = [[s1 then:^RACSignal * _Nonnull{ // 1执行完执行2， 2执行完执行3
        return s2;
    }] then:^RACSignal * _Nonnull{
        return s3;
    }];
    
    __unused RACSignal *totoalSig = [RACSignal combineLatest:@[s1, s2, s3]];
}

- (RACSignal *)signalFromURLStr:(NSString *)url {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                NSError *e;
                NSJSONSerialization *ser = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                if (e) {
                    [subscriber sendError:e];
                } else {
                    [subscriber sendNext:ser];
                    [subscriber sendCompleted];
                }
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            // 释放资源
        }];
    }];
}

- (void)gcdGroupSync {
    // 多请求需要同步
    dispatch_group_t group = dispatch_group_create();
    
    // 如果是有顺序的，还要加同步锁
    
    // 请求1
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
    });
    // 请求2
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
    });
    
    // 处理
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
    });
}


- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

@end
