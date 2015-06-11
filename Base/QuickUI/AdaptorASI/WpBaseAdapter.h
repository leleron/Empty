//
//  WpBaseAdapter.h
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-10.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import <Foundation/Foundation.h>


// WpResponse
@interface WpResponse : NSObject

@property (nonatomic, assign) id adapter;
@property (strong,nonatomic)NSString* status;
@property (nonatomic, assign) NSInteger retCode;
@property (nonatomic, strong) NSString* retString;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) id errorData;
@property(nonatomic,strong)NSString* jsonBody;
@property(nonatomic,strong)NSString* retServiceTime;
@property(strong,nonatomic)NSString* sessionId;
//

@end


// WpBaseAdapter
typedef void(^ResponseBlock)(WpResponse* response, id senderObj);

@interface WpBaseAdapter : NSOperation
{
    NSMutableDictionary* paramDict;
    WpResponse* response;
    
    NSDictionary* needHttpScheme;
}

- (id)initWithTarget:(id)_target selector:(SEL)_selector;
- (id)initWithResponse:(ResponseBlock)_responseBlock;
- (void)removeTarget;
//- (NSString*)getOperationType;
//- (void)getPostBody;
//- (void)getBigPostBody;
- (void)parseResponseRoot:(NSDictionary*)root;
- (void)parseErrorResponseRoot:(NSDictionary*)root;
//- (double)getTimeOutSeconds;
- (BOOL)isShowContent;

@property(nonatomic,strong)NSDictionary* params;
@property(nonatomic,strong)NSString* operationType;
@property(nonatomic,strong)NSString* sendMethod;
@property(nonatomic,assign)double timeOutRequest;
@end
