//
//  MXNetworking.h
//  Meniny
//
//  Created by Meniny on 2012-09-10.
//  Copyright (c) 2012 Meniny. All rights reserved.
//
//  Powerd by Meniny.
//  See http://www.meniny.cn/ for more informations.
//

#import <Foundation/Foundation.h>
#import "NSJSONSerialization+RemovingNulls.h"

typedef enum {

    /**
     * 0
     */
    ResponseStatusNoNetwork = 0,
    

    /**
     * 100
     */
    ResponseStatusContinue = 100,

    /**
     * 101
     */
    ResponseStatusSwitchingProtocols = 101,
    

    /**
     * 102
     */
    ResponseStatusProcessing = 102,//WebDAV（RFC 2518）


    /**
     * 200
     */
    ResponseStatusSuccess = 200,

    /**
     * 201
     */
    ResponseStatusCreated = 201,

    /**
     * 202
     */
    ResponseStatusAccepted = 202,

    /**
     * 203
     */
    ResponseStatusNonAuthoritativeInformation = 203,

    /**
     * 204
     */
    ResponseStatusNoContent = 204,


    /**
     * 205
     */
    ResponseStatusResetContent = 205,

    /**
     * 206
     */
    ResponseStatusPartialContent = 206,

    /**
     * 207
     */
    ResponseStatusMultiStatus = 207,//WebDAV（RFC 2518）

    /**
     * 300
     */
    ResponseStatusRequestError = 300,// 300 Multiple Choices

    /**
     *
     */
//    ResponseStatusUnknownError = 301,

    /**
     * 301
     */
    ResponseStatusMovedPermanently = 301,

    /**
     * 302
     */
    ResponseStatusMoveTemporarily = 302,

    /**
     * 303
     */
    ResponseStatusSeeOther = 303,

    /**
     * 304
     */
    ResponseStatusNotModified = 304,

    /**
     * 305
     */
    ResponseStatusUseProxy = 305,

    /**
     * 306
     */
    ResponseStatusSwitchProxy = 306,

    /**
     * 307
     */
    ResponseStatusTemporaryRedirect = 307,

    /**
     * 400
     */
    ResponseStatusBadRequest = 400,

    /**
     * 401
     */
    ResponseStatusUnauthorized = 401,

    /**
     * 402
     */
    ResponseStatusPaymentRequired = 402,

    /**
     * 403
     */
    ResponseStatusForbidden = 403,//ResponseStatusRefused

    /**
     * 404
     */
    ResponseStatusNotFound = 404,

    /**
     * 405
     */
    ResponseStatusMethodNotAllowed = 405,

    /**
     * 406
     */
    ResponseStatusNotAcceptable = 406,

    /**
     * 407
     */
    ResponseStatusProxyAuthenticationRequired = 407,

    /**
     * 408
     */
    ResponseStatusRequestTimeout = 408,

    /**
     * 409
     */
    ResponseStatusConflict = 409,

    /**
     * 410
     */
    ResponseStatusGone = 410,

    /**
     * 411
     */
    ResponseStatusLengthRequired = 411,

    /**
     * 412
     */
    ResponseStatusPreconditionFailed = 412,

    /**
     * 413
     */
    ResponseStatusRequestEntityTooLarge = 413,

    /**
     * 414
     */
    ResponseStatusRequestURITooLong = 414,

    /**
     * 415
     */
    ResponseStatusUnsupportedMediaType = 415,

    /**
     * 416
     */
    ResponseStatusRequestedRangeNotSatisfiable = 416,

    /**
     * 417
     */
    ResponseStatusExpectationFailed = 417,

    /**
     * 421
     */
    ResponseStatusTooManyConnections = 421,

    /**
     * 422
     */
    ResponseStatusUnprocessableEntity = 422,

    /**
     * 423
     */
    ResponseStatusLocked = 423,

    /**
     * 424
     */
    ResponseStatusFailedDependency = 424,

    /**
     * 425
     */
    ResponseStatusUnorderedCollection = 425,

    /**
     * 426
     */
    ResponseStatusUpgradeRequired = 426,

    /**
     * 449
     */
    ResponseStatusRetryWith = 449,// Microsoft
    

    /**
     * 500
     */
    ResponseStatusInternalServerError = 500,

    /**
     * 501
     */
    ResponseStatusNotImplemented = 501,

    /**
     * 502
     */
    ResponseStatusBadGateway = 502,

    /**
     * 503
     */
    ResponseStatusServiceUnavailable = 503,

    /**
     * 504
     */
    ResponseStatusGatewayTimeout = 504,

    /**
     * 505
     */
    ResponseStatusHTTPVersionNotSupported = 505,

    /**
     * 506
     */
    ResponseStatusVariantAlsoNegotiates = 506,//RFC 2295

    /**
     * 507
     */
    ResponseStatusInsufficientStorage = 507,

    /**
     * 509
     */
    ResponseStatusBandwidthLimitExceeded = 509,

    /**
     * 510
     */
    ResponseStatusNotExtended = 510,
    

    /**
     * 600
     */
    ResponseStatusUnparseableResponseHeaders = 600
} ResponseStatus;

typedef enum {
    
    /**
     * 0
     */
    ResponseStatus0 = ResponseStatusNoNetwork,
    
    
    /**
     * 100
     */
    ResponseStatus100 = ResponseStatusContinue,
    
    /**
     * 101
     */
    ResponseStatus101 = ResponseStatusSwitchingProtocols,
    
    
    /**
     * 102
     */
    ResponseStatus102 = ResponseStatusProcessing,//WebDAV（RFC 2518）
    
    
    /**
     * 200
     */
    ResponseStatus200 = ResponseStatusSuccess,
    
    /**
     * 201
     */
    ResponseStatus201 = ResponseStatusCreated,
    
    /**
     * 202
     */
    ResponseStatus202 = ResponseStatusAccepted,
    
    /**
     * 203
     */
    ResponseStatus203 = ResponseStatusNonAuthoritativeInformation,
    
    /**
     * 204
     */
    ResponseStatus204 = ResponseStatusNoContent,
    
    
    /**
     * 205
     */
    ResponseStatus205 = ResponseStatusResetContent,
    
    /**
     * 206
     */
    ResponseStatus206 = ResponseStatusPartialContent,
    
    /**
     * 207
     */
    ResponseStatus207 = ResponseStatusMultiStatus,//WebDAV（RFC 2518）
    
    /**
     * 300
     */
    ResponseStatus300 = ResponseStatusRequestError,// 300 Multiple Choices
    
    /**
     *
     */
    //    ResponseStatus301 = ResponseStatusUnknownError,
    
    /**
     * 301
     */
    ResponseStatus301 = ResponseStatusMovedPermanently,
    
    /**
     * 302
     */
    ResponseStatus302 = ResponseStatusMoveTemporarily,
    
    /**
     * 303
     */
    ResponseStatus303 = ResponseStatusSeeOther,
    
    /**
     * 304
     */
    ResponseStatus304 = ResponseStatusNotModified,
    
    /**
     * 305
     */
    ResponseStatus305 = ResponseStatusUseProxy,
    
    /**
     * 306
     */
    ResponseStatus306 = ResponseStatusSwitchProxy,
    
    /**
     * 307
     */
    ResponseStatus307 = ResponseStatusTemporaryRedirect,
    
    /**
     * 400
     */
    ResponseStatus400 = ResponseStatusBadRequest,
    
    /**
     * 401
     */
    ResponseStatus401 = ResponseStatusUnauthorized,
    
    /**
     * 402
     */
    ResponseStatus402 = ResponseStatusPaymentRequired,
    
    /**
     * 403
     */
    ResponseStatus403 = ResponseStatusForbidden,//ResponseStatusRefused
    
    /**
     * 404
     */
    ResponseStatus404 = ResponseStatusNotFound,
    
    /**
     * 405
     */
    ResponseStatus405 = ResponseStatusMethodNotAllowed,
    
    /**
     * 406
     */
    ResponseStatus406 = ResponseStatusNotAcceptable,
    
    /**
     * 407
     */
    ResponseStatus407 = ResponseStatusProxyAuthenticationRequired,
    
    /**
     * 408
     */
    ResponseStatus408 = ResponseStatusRequestTimeout,
    
    /**
     * 409
     */
    ResponseStatus409 = ResponseStatusConflict,
    
    /**
     * 410
     */
    ResponseStatus410 = ResponseStatusGone,
    
    /**
     * 411
     */
    ResponseStatus411 = ResponseStatusLengthRequired,
    
    /**
     * 412
     */
    ResponseStatus412 = ResponseStatusPreconditionFailed,
    
    /**
     * 413
     */
    ResponseStatus413 = ResponseStatusRequestEntityTooLarge,
    
    /**
     * 414
     */
    ResponseStatus414 = ResponseStatusRequestURITooLong,
    
    /**
     * 415
     */
    ResponseStatus415 = ResponseStatusUnsupportedMediaType,
    
    /**
     * 416
     */
    ResponseStatus416 = ResponseStatusRequestedRangeNotSatisfiable,
    
    /**
     * 417
     */
    ResponseStatus417 = ResponseStatusExpectationFailed,
    
    /**
     * 421
     */
    ResponseStatus421 = ResponseStatusTooManyConnections,
    
    /**
     * 422
     */
    ResponseStatus422 = ResponseStatusUnprocessableEntity,
    
    /**
     * 423
     */
    ResponseStatus423 = ResponseStatusLocked,
    
    /**
     * 424
     */
    ResponseStatus424 = ResponseStatusFailedDependency,
    
    /**
     * 425
     */
    ResponseStatus425 = ResponseStatusUnorderedCollection,
    
    /**
     * 426
     */
    ResponseStatus426 = ResponseStatusUpgradeRequired,
    
    /**
     * 449
     */
    ResponseStatus449 = ResponseStatusRetryWith,// Microsoft
    
    
    /**
     * 500
     */
    ResponseStatus500 = ResponseStatusInternalServerError,
    
    /**
     * 501
     */
    ResponseStatus501 = ResponseStatusNotImplemented,
    
    /**
     * 502
     */
    ResponseStatus502 = ResponseStatusBadGateway,
    
    /**
     * 503
     */
    ResponseStatus503 = ResponseStatusServiceUnavailable,
    
    /**
     * 504
     */
    ResponseStatus504 = ResponseStatusGatewayTimeout,
    
    /**
     * 505
     */
    ResponseStatus505 = ResponseStatusHTTPVersionNotSupported,
    
    /**
     * 506
     */
    ResponseStatus506 = ResponseStatusVariantAlsoNegotiates,//RFC 2295
    
    /**
     * 507
     */
    ResponseStatus507 = ResponseStatusInsufficientStorage,
    
    /**
     * 509
     */
    ResponseStatus509 = ResponseStatusBandwidthLimitExceeded,
    
    /**
     * 510
     */
    ResponseStatus510 = ResponseStatusNotExtended,
    
    
    /**
     * 600
     */
    ResponseStatus600 = ResponseStatusUnparseableResponseHeaders
} ResponseStatusNumber;

typedef void (^ResponseCallback)(ResponseStatus status);

FOUNDATION_EXTERN NSString * const kContentLengthKey;
FOUNDATION_EXTERN NSString * const kContentTypeKey;

FOUNDATION_EXTERN NSString * const kHTTPMethodGet;
FOUNDATION_EXTERN NSString * const kHTTPMethodPost;
FOUNDATION_EXTERN NSString * const kHTTPMethodPut;
FOUNDATION_EXTERN NSString * const kHTTPMethodDelete;

FOUNDATION_EXTERN NSString * const kContentTypeData;
FOUNDATION_EXTERN NSString * const kContentTypeJSON;
FOUNDATION_EXTERN NSString * const kContentTypeMultipart;

// Response object could be NSArray, NSDictionary or NSString
typedef void (^FullResponseCallback)(ResponseStatus status, id responseObject);

typedef enum {
    RequestTypeURL = 0,
    RequestTypeJSON,
    RequestTypeData,
    RequestTypeMultipart
} RequestType;

@interface MXNetworking : NSObject

// Use this for main requests
+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data callback:(FullResponseCallback)callback;
+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data timeOut:(NSTimeInterval)timeOut callback:(FullResponseCallback)callback;
@end
