//
//  WebViewTableViewCell.m
//  tableViewContainWebView
//
//  Created by maple on 16/8/29.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "WebViewTableViewCell.h"
#import <WebKit/WebKit.h>

@interface WebViewTableViewCell ()<WKNavigationDelegate>

@end

@implementation WebViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __block CGFloat height = 0;
    NSString *js = @"document.body.scrollHeight;";
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:--%@", error);
            return;
        }
        height = [result floatValue];
        NSLog(@"WKWebView---result:--%@", result);
        //防止死循环: 加载webView -> 调用代理刷新表格 -> 加载webView
        if (self.model.rowHeight != height) {
            NSLog(@"WKWebView---调用代理");
             self.model.rowHeight = height;
            if ([self.delegate respondsToSelector:@selector(webViewTableViewCellDidLoad:)]) {
                [self.delegate webViewTableViewCellDidLoad:self];
            }
        }
    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"接收到服务器跳转请求之后调用");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"在发送请求之前，决定是否跳转");
    NSString *targetUrl = navigationAction.targetFrame.request.URL.absoluteString;
    NSString *sourceUrl = navigationAction.sourceFrame.request.URL.absoluteString;
    NSLog(@"source:--%@\ntarget:--%@", sourceUrl, targetUrl);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebView *webView = [[WKWebView alloc] init];
        _webView = webView;
        webView.navigationDelegate = self;
        //取消滚动
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.bounces = NO;
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:webView];
        //设置约束，四边贴着contenView
        webView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    return _webView;
}


@end
