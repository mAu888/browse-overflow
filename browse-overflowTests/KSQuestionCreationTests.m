//
//  KSQuestionCreationTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionCreationTests.h"
#import "KSStackOverflowManager.h"
#import "KSStackOverflowCommunicator.h"
#import "KSMockStackOverflowManagerDelegate.h"
#import "KSTopic.h"

#import "OCMock.h"
#import "OCMockObject.h"
#import "OCMConstraint.h"

@implementation KSQuestionCreationTests
{
  KSStackOverflowManager *_mgr;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _mgr = [[KSStackOverflowManager alloc] init];
}

- (void) tearDown
{
  _mgr = nil;
}

- (void) testNonConformingObjectCannotBeDelegate
{
  STAssertThrows(_mgr.delegate = (id <KSStackOverflowManagerDelegate>)[NSNull null], @"Non-conforming object can not be delegate");
}

- (void) testConformingObjectCanBeDelegate
{
  id <KSStackOverflowManagerDelegate> delegate = [[KSMockStackOverflowManagerDelegate alloc] init];
  STAssertNoThrow(_mgr.delegate = delegate, @"Conforming object can be delegate");
}

- (void) testManagerAcceptsNilAsADelegate
{
  STAssertNoThrow(_mgr.delegate = nil, @"nil should be accepted as a valid delegate");
}

- (void) testAskingForQuestionMeansRequestingData
{
  id comm = [OCMockObject mockForClass:[KSStackOverflowCommunicator class]];
  [[comm expect] searchForQuestionsWithTag:[OCMArg checkWithBlock:^BOOL(id arg) {
    return arg != nil && [arg isKindOfClass:[NSString class]];
  }]];
  
  _mgr.communicator = comm;
  
  KSTopic *topic = [[KSTopic alloc] initWithName:@"iPhone" tag:@"iphone"];
  [_mgr fetchQuestionsOnTopic:topic];
  
  [comm verify];
}

- (void) testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
  id delegate = [OCMockObject mockForProtocol:@protocol(KSStackOverflowManagerDelegate)];
  
  [[delegate expect] fetchingQuestionsOnTopic:[OCMArg isNil] failedWithError:[OCMArg checkWithBlock:^BOOL(id arg) {
    return [arg isKindOfClass:[NSError class]] && [[(NSError *)arg domain] isEqualToString:KSStackOverflowManagerError];
  }]];
  
  _mgr.delegate = delegate;
  NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
  
  [_mgr searchingForQuestionsFailedWithError:underlyingError];
  
  [delegate verify];
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
  id delegate = [OCMockObject mockForProtocol:@protocol(KSStackOverflowManagerDelegate)];
  
  _mgr.delegate = delegate;
  NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
  
  [[delegate expect] fetchingQuestionsOnTopic:[OCMArg isNil] failedWithError:[OCMArg checkWithBlock:^BOOL(id arg) {
    return [[arg userInfo] objectForKey:NSUnderlyingErrorKey] == underlyingError;
  }]];
  
  [_mgr searchingForQuestionsFailedWithError:underlyingError];

  [delegate verify];
}

@end
