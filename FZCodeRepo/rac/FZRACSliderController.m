//
//  FZRACSliderController.m
//  FZCodeRepo
//
//  Created by may on 2018/9/6.
//  Copyright © 2018 zhfeze. All rights reserved.
//

#import "FZRACSliderController.h"

#import <ReactiveObjC.h>

@interface FZRACSliderController ()
@property (weak, nonatomic) IBOutlet UISlider *rs;
@property (weak, nonatomic) IBOutlet UISlider *gs;
@property (weak, nonatomic) IBOutlet UISlider *bs;

@property (weak, nonatomic) IBOutlet UITextField *rt;
@property (weak, nonatomic) IBOutlet UITextField *gt;
@property (weak, nonatomic) IBOutlet UITextField *bt;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIView *vi;

@end

@implementation FZRACSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rt.text = self.gt.text = self.bt.text = @"0.5";
    
    [self blindSlider:_rs label:_rt];
    [self blindSlider:_gs label:_gt];
    [self blindSlider:_bs label:_bt];
}

- (void)blindSlider:(UISlider *)slider label:(UITextField *)textField {
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalTextField = [textField rac_newTextChannel];
    
    [signalTextField subscribe:signalSlider];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalTextField];
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
