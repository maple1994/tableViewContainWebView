//
//  ViewController.m
//  tableViewContainWebView
//
//  Created by maple on 16/8/29.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "ViewController.h"
#import "WebViewTableViewCell.h"
#import "CellModel.h"


@interface ViewController ()<WebViewTableViewCellDelegate>
@property (nonatomic, strong) CellModel *cellModel;
@property (nonatomic, assign) BOOL reused;
@end

@implementation ViewController

static NSString *ID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellModel = [[CellModel alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

#pragma tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        WebViewTableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"web"];
        if (webCell == nil) {
           webCell = [[WebViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"web"];
        }else{
            //有可以复用的cell则直接返回
            NSLog(@"重用");
            return webCell;
        }
        webCell.delegate = self;
        [webCell.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blog.csdn.net/qq_30513483/article/details/51496539"]]];
        webCell.model = self.cellModel;
        return webCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return self.cellModel.rowHeight;
    }else {
        return 30;
    }
}


#pragma mark - WebViewTableViewCell
- (void)webViewTableViewCellDidLoad:(WebViewTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
