//
//  SXNetworkManager.m
//  NetRequest
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 saint. All rights reserved.
//

#import "SXNetworkManager.h"

#define SERVERURL @"https://www.baidu.com/"

@interface SXNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@end

@implementation SXNetworkManager

static SXNetworkManager * networkManager = nil;

/**
 *  单例
 *
 *  @return 网络请求实例
 */

+(instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [[SXNetworkManager alloc] init];
        }
    });
    return networkManager;
}

/**
 *  初始化
 *
 *  @return 基本的请求设置
 */

-(instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        // 设置请求以及相应的序列化器
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        self.sessionManager.requestSerializer.timeoutInterval = 15;
        // 设置响应内容的类型
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    }
    return self;
}

/**
 *  常用网络请求方式
 *
 *  @param requestMethod 请求方式
 *  @param apiPath 方法的链接
 *  @param parameters 参数
 *  @param completeBlock 回调
 *  @return value description
 */

-(nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                            apiPath:(nonnull NSString *)apiPath
                                         parameters:(nullable id)parameters
                                      completeBlock:(nullable completeBlock)completeBlock{
    // 请求的地址
    NSString * requestPath = [SERVERURL stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case GET:
            {
                task = [self.sessionManager GET:requestPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    completeBlock(responseObject,nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    completeBlock(nil,error);
                }];
            }
            break;
        case POST:
        {
            task = [self.sessionManager POST:requestPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completeBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,error);
            }];
        }
            break;
        case PUT:
        {
            task = [self.sessionManager PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completeBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,error);
            }];
        }
            break;
        case PATCH:
            {
                task = [self.sessionManager PATCH:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    completeBlock(responseObject,nil);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    completeBlock(nil,error);
                }];
            }
            break;
        case DELETE:
        {
            task = [self.sessionManager DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completeBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,error);
            }];
        }
            break;
        default:
            break;
    }
    return task;
}

/**
 *  上传图片
 *
 *  @param apiPath 方法链接
 *  @param parameters 参数
 *  @param imageArray 图片
 *  @param completeBlock 回调
 *  @return description
 */

-(nullable NSURLSessionDataTask *)sendPOSTRequestWithApiPath:(nonnull NSString *)apiPath
                                                    parameters:(nullable id)parameters
                                                    imageArray:(NSArray *_Nullable)imageArray
                                                 completeBlock:(nullable completeBlock)completeBlock; {
    // 请求的地址
    NSString * requestPath = [SERVERURL stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    task = [self.sessionManager POST:requestPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i = 0;
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            NSData * imgData = UIImageJPEGRepresentation(image, 0.5);
        // 拼接Data
           [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
           i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completeBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,error);
    }];
    return task;
}

#pragma mark 报错信息
/**
 *  处理报错信息
 *
 *  @param error AFN返回的错误信息
 *  @param task 任务
 *  @return description
 */

-(NSString *)failHandleWithErrorResponse:(NSError * _Nullable)error task:(NSURLSessionDataTask * _Nullable)task {
//    __block NSString * message = nil;
    NSData * afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLRequestErrorKey];
    return [[NSString alloc] initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding];
}

@end
