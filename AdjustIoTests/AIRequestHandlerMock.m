//
//  AIRequestHandlerMock.m
//  AdjustIo
//
//  Created by Pedro Filipe on 10/02/14.
//  Copyright (c) 2014 adeven. All rights reserved.
//

#import "AIRequestHandlerMock.h"
#import "AILoggerMock.h"
#import "AIAdjustIoFactory.h"
#import "AIResponseData.h"

static NSString * const prefix = @"AIRequestHandler ";

@interface AIRequestHandlerMock()

@property (nonatomic, assign) id<AIPackageHandler> packageHandler;
@property (nonatomic, assign) AILoggerMock *loggerMock;

@end

@implementation AIRequestHandlerMock

- (id)initWithPackageHandler:(id<AIPackageHandler>) packageHandler {
    self = [super init];
    if (self == nil) return nil;
    
    self.packageHandler = packageHandler;
    self.loggerMock = (AILoggerMock *) [AIAdjustIoFactory logger];
    
    [self.loggerMock test:[prefix stringByAppendingString:@"initWithPackageHandler"]];

    self.connectionError = NO;
    
    return self;
}

- (void)sendPackage:(AIActivityPackage *)activityPackage {
    [self.loggerMock test:[prefix stringByAppendingString:@"sendPackage"]];

    AIResponseData *responseData;
    
    if (self.connectionError) {
        responseData = [[AIResponseData alloc] initWithError:@"connection error"];
    } else {
        responseData = [[AIResponseData alloc] initWithJsonString:@"{\"tracker_token\":\"token\",\"tracker_name\":\"name\"}"];
    }

    [self.packageHandler finishedTrackingActivity:activityPackage withResponse:responseData];

    if (self.connectionError) {
        [self.packageHandler closeFirstPackage];
    } else {
        [self.packageHandler sendNextPackage];
    }
}


@end
