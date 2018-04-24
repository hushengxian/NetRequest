//
//  SXNetworkManager.h
//  NetRequest
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 saint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE
};

typedef void(^completeBlock)( NSDictionary *_Nullable object,NSError * _Nullable error);
typedef void(^HttpDownloadProgressBlock)(CGFloat progress);
typedef void(^HttpSuccessBlock)(id _Nullable json);
typedef void(^HttpFailureBlock)(NSError * _Nullable error);

@interface SXNetworkManager : NSObject

/**
 *  单例
 *
 *  @return 网络请求类的实例
 */

+(nonnull instancetype)defaultManager;

#pragma mark 常用网络请求方式

 /**
  *  常用网络请求方式
  *
  *  @param requestMethod 请求方式
  *  @param apiPath 方法的链接
  *  @param parameters 参数
  *  @param completeBlock 代码块回调
  *  @return value description
  */

-(nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                            apiPath:(nonnull NSString *)apiPath
                                         parameters:(nullable id)parameters
                                      completeBlock:(nullable completeBlock)completeBlock;

#pragma mark POST 上传图片
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
                                                 completeBlock:(nullable completeBlock)completeBlock;

#pragma mark 下载文件
/**
 *  下载文件
 *
 *  @param apiPath 方法链接
 *  @param success 下载成功
 *  @param failure 下载失败
 *  @param progress 下载进度
 */

-(void)downloadWithApiPath:(nonnull NSString *)apiPath
                   success:(nullable HttpSuccessBlock)success
                   failure:(nullable HttpFailureBlock)failure
                  progress:(nullable HttpDownloadProgressBlock)progress;

@end
