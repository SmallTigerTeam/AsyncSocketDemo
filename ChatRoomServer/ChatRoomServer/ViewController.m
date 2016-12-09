//
//  ViewController.m
//  ChatRoomServer
//
//  Created by lixiaohu on 16/12/9.
//  Copyright © 2016年 lixiaohu. All rights reserved.
//

#import "ViewController.h"
#import "STConfig.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak) IBOutlet NSTextField *ipAddress;
@property (weak) IBOutlet NSTextField *port;
@property (unsafe_unretained) IBOutlet NSTextView *contentTextView;

@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) NSMutableString *contentString;
@property (nonatomic, strong) NSMutableArray *clinetArray;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天室服务端";
    self.ipAddress.stringValue = [STConfig getIPAddress];
    self.port.stringValue = @"50002";
    
}

#pragma mark - socket delegate
//Called when a socket accepts a connection
- (void)socket:(GCDAsyncSocket *)serverceSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{
    NSLog(@"a socket accepts a connection");
    
    if (clientSocket) {
        [self.clinetArray addObject:clientSocket];
    }
    //当客户端一连接成功就发送数据给它
    NSMutableString *serverceStr = [NSMutableString string];
    [serverceStr appendString:@"欢迎来到ST聊天室,这里都是精英"];
    [self appendContentStr:[NSString stringWithFormat:@"当前累计共有 %ld 个客户端连接", self.clinetArray.count]];
    
    //    向调用方法的socket写入数据即是这里是向客户端socket发送数据
    [clientSocket writeData:[serverceStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    //监听客户端发送数据
    [clientSocket readDataWithTimeout:-1 tag:0];
    
    
}
//Called when a socket has completed reading the requested data into memory
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *clientString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    for (GCDAsyncSocket *socket in self.clinetArray) {
        if (socket != clientSocket && clientString) {  //不给自己发送消息
            [socket writeData:[clientString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
    }
    
#warning mark - 每次读完数据后都要调用一次监听数据的方法
    [clientSocket readDataWithTimeout:-1 tag:0];
}
- (IBAction)stop:(id)sender {
}

- (IBAction)start:(id)sender {
    [self startListener];
}

#pragma mark - private methods

- (void)startListener{
    NSError *error = nil;
    [self.serverSocket acceptOnPort:50003 error:&error];
    
    if (!error) {
        NSLog(@"服务端开启成功");
        [self appendContentStr:@"服务端开启成功"];
    }else{
        NSLog(@"服务端开启失败：%@", error);
        
        [self appendContentStr:[NSString stringWithFormat:@"服务端开启失败%@", error.userInfo[@"NSLocalizedDescription"]]];
    }
}

- (void)appendContentStr:(NSString *)content{
    [self.contentString appendString:[NSString stringWithFormat:@"%@\n-----------------\n", content]];
    self.contentTextView.string = self.contentString;
}
#pragma mark - setter & getter

- (GCDAsyncSocket *)serverSocket{
    if (!_serverSocket) {
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    
    return _serverSocket;
}

- (NSMutableString *)contentString{
    if (!_contentString) {
        _contentString = [[NSMutableString alloc] init];
    }
    
    return _contentString;
}

- (NSMutableArray *)clinetArray{
    if (!_clinetArray) {
        _clinetArray = @[].mutableCopy;
    }
    
    return _clinetArray;
}
@end
