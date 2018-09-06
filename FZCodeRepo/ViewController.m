//
//  ViewController.m
//  FZCodeRepo
//
//  Created by zfz on 2018/8/13.
//  Copyright © 2018年 zhfeze. All rights reserved.
//

#import "ViewController.h"

#import "FZRACSliderController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.table];
    [self.table reloadData];
}

#pragma mark - tableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"racSlider";
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        FZRACSliderController *vc = [FZRACSliderController new];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - getters

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
