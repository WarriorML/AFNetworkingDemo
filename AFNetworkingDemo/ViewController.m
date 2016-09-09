//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by MengLong Wu on 16/9/9.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    AFNetworking 网络请求第三方库  3.0版本之后全部基于NSURLSession
//    ASIHTTPRequest
    
//    [self getCase];
    
//    [self postCase];
    
//    [self upload];
    
//    [self download];
    
    [self judgeNetState];
}

#pragma mark -简单get请求
- (void)getCase
{
    NSString *urlStr = @"http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=v0pnQxMbgohmSqokyRDYr26o";
//    对URL中的汉字进行编码,并且去掉空格等无效字符
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
//    创建单例对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  GET请求
     *  @param  GET     网址字符串
     *  @param  parameters 参数
     *  @param  progress 进度
     *  @param  success 请求成功返回的数据
     *  @param  failure 请求失败
     *  @return
     */
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}
#pragma mark -GET请求
- (void)postCase
{
//    请求网址字符串
    NSString *urlStr = @"https://api.weibo.com/oauth2/authorize";
//    参数字符串
    NSDictionary *dic = @{@"client_id":@"1629025799",@"redirect_uri":@"https://www.baidu.com"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    出现code=3840的错误，需要设置下面一行代码
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    AFNetworking 默认接受json格式的数据，如果想要接收text/html类型的数据，需要设置以下一行代码，如果没有这行代码，会出现code=-1016的错误
//    acceptableContentTypes 设置可以接收的内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark -上传
- (void)upload
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/DownloadAndUpload/upload"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    UIImage *image = [UIImage imageNamed:@"123.png"];
    
    NSData *data = UIImagePNGRepresentation(image);
    
    request.HTTPMethod = @"POST";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    上传一张图片
    NSURLSessionDataTask *task = [manager uploadTaskWithRequest:request fromData:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
//    上传时需要手动开启task
    [task resume];
}
#pragma mark -下载
- (void)download
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/DownloadAndUpload/123.zip"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        下载进度
        float progress = (float)downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
        
        NSLog(@"当前下载进度为:%.2f%%",progress*100);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
//        返回一个url，文件最终的存储路径
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/123.zip"];
        
        NSLog(@"%@",path);
        
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [task resume];
    
}
#pragma mark -检测网络状态
- (void)judgeNetState
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    
    switch (manager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
        {
            NSLog(@"未知网络");
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            NSLog(@"无网络");
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            NSLog(@"WIFI");
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            NSLog(@"手机网络");
        }
            break;
            
        default:
            break;
    }
    
//    开始检测
    [manager startMonitoring];
}







@end
