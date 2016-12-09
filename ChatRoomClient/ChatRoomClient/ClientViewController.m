//
//  ClientViewController.m
//  ChatRoomClient
//
//  Created by lixiaohu on 16/12/8.
//  Copyright © 2016年 lixiaohu. All rights reserved.
//
/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
#import "ClientViewController.h"
#import "STConfig.h"
#import "GCDAsyncSocket.h"

@interface ClientViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) NSMutableString *contentString;

@end

@implementation ClientViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ipLabel.text = @"192.168.164.127";
    self.portLabel.text = @"50002";
}

#pragma mark - user action
- (IBAction)connect:(id)sender {
    NSError *error = nil;
    [self.clientSocket connectToHost:@"192.168.164.127" onPort:50003 error:&error];
    if (!error) {
        NSLog(@"客户端连接成功");
        [self appendContentStr:@"客户端连接成功"];
    }else{
        NSLog(@"客户端连接失败");
        [self appendContentStr:[NSString stringWithFormat:@"客户端连接失败%@", error.userInfo[@"NSLocalizedDescription"]]];

    }
}
- (IBAction)disConnent:(id)sender {
    [self.clientSocket disconnect];
}
- (IBAction)send:(id)sender {
}

#pragma mark - private methods

- (void)appendContentStr:(NSString *)content{
    [self.contentString appendString:[NSString stringWithFormat:@"%@\n-----------------\n", content]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentTextView.text = self.contentString;

    });
}

#pragma mark - socket delegate

//Called when a socket connects and is ready for reading and writing
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"is ready for reading and writing");
    [sock readDataWithTimeout:-1 tag:0];
}
//Called when a socket disconnects with or without error
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"disconnect");
}
// Called when a socket has completed reading the requested data into memory
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"reading the requested data into memory");
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (message.length) {
        [self appendContentStr:message];
    }
}


#pragma mark - setter & getter
- (GCDAsyncSocket *)clientSocket{
    if (!_clientSocket) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    
    return _clientSocket;
}

- (NSMutableString *)contentString{
    if (!_contentString) {
        _contentString = [[NSMutableString alloc] init];
    }
    
    return _contentString;
}

@end
