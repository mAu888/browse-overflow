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
#import "KSQuestionBuilder.h"
#import "KSTopic.h"

#import "OCMock.h"
#import "OCMockObject.h"
#import "OCMConstraint.h"

#import "KSQuestionBuilderMock.h"

@implementation KSQuestionCreationTests
{
  @private
  NSError *_underlyingError;
  KSStackOverflowManager *_mgr;
  id _delegate;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _mgr = [[KSStackOverflowManager alloc] init];
  _delegate = [OCMockObject mockForProtocol:@protocol(KSStackOverflowManagerDelegate)];
  _underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
  
  _mgr.delegate = _delegate;
}

- (void) tearDown
{
  _mgr = nil;
  _delegate = nil;
  _underlyingError = nil;
}

- (void) testNonConformingObjectCannotBeDelegate
{
  STAssertThrows(_mgr.delegate = (id <KSStackOverflowManagerDelegate>)[NSNull null], @"Non-conforming object can not be delegate");
}

- (void) testConformingObjectCanBeDelegate
{
  STAssertNoThrow(_mgr.delegate = _delegate, @"Conforming object can be delegate");
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
  [[_delegate expect] fetchingQuestionsFailedWithError:[OCMArg checkWithBlock:^BOOL(id arg) {
    return [arg isKindOfClass:[NSError class]] && [[(NSError *)arg domain] isEqualToString:KSStackOverflowManagerError];
  }]];
  
  [_mgr searchingForQuestionsFailedWithError:_underlyingError];
  
  [_delegate verify];
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
  _mgr.delegate = _delegate;
  
  [[_delegate expect] fetchingQuestionsFailedWithError:[OCMArg checkWithBlock:^BOOL(id arg) {
    return [[arg userInfo] objectForKey:NSUnderlyingErrorKey] == _underlyingError;
  }]];
  
  [_mgr searchingForQuestionsFailedWithError:_underlyingError];

  [_delegate verify];
}

- (void) testQuestionJSONIsPassedToQuestionBuilder
{
  KSQuestionBuilderMock *builder = [[KSQuestionBuilderMock alloc] init];

  builder.arrayToReturn = nil;
  builder.errorToSet = nil;
  
  [[_delegate stub] fetchingQuestionsFailedWithError:[OCMArg any]];
  
  _mgr.questionBuilder = builder;
  [_mgr receivedQuestionJSON:@"{ \"fake\": \"json\" }"];
  
  _mgr.questionBuilder = nil;
  
  STAssertEqualObjects(builder.JSON, @"{ \"fake\": \"json\" }", @"Builder is called by manager");
}

- (void) testDelegateNotifiedOfErrorWhenQuestionBuilderFails
{
  KSQuestionBuilderMock *builder = [[KSQuestionBuilderMock alloc] init];

  builder.arrayToReturn = nil;
  builder.errorToSet = _underlyingError;
  
  [[_delegate expect] fetchingQuestionsFailedWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [[obj userInfo] objectForKey:NSUnderlyingErrorKey] == _underlyingError;
  }]];
  
  _mgr.questionBuilder = builder;
  [_mgr receivedQuestionJSON:@"{ \"fake\": \"json\" }"];
  
  _mgr.questionBuilder = nil;
  
  [_delegate verify];
}

@end
