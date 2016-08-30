//
//  WebViewTableViewCell.h
//  tableViewContainWebView
//
//  Created by maple on 16/8/29.
//  Copyright © 2016年 maple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CellModel.h"

@class WebViewTableViewCell;
@protocol WebViewTableViewCellDelegate <NSObject>

- (void)webViewTableViewCellDidLoad:(WebViewTableViewCell *)cell;

@end

@interface WebViewTableViewCell : UITableViewCell

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, strong) CellModel *model;

@property (nonatomic, weak) id<WebViewTableViewCellDelegate> delegate;


@end
