//
//  KSQuestionCreationTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionCreationWorkflowTests.h"
#import "KSStackOverflowManager.h"
#import "KSStackOverflowCommunicator.h"
#import "KSQuestionBuilder.h"
#import "KSTopic.h"
#import "KSQuestion.h"

#import "OCMock.h"
#import "OCMockObject.h"
#import "OCMConstraint.h"

#import "KSQuestionBuilderMock.h"

@implementation KSQuestionCreationWorkflowTests
{
  @private
  NSError *_underlyingError;
  NSArray *_questionArray;
  NSString *_questionJSON;
  KSStackOverflowManager *_mgr;
  KSQuestionBuilderMock *_questionBuilder;
  id _delegate;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _mgr = [[KSStackOverflowManager alloc] init];
  _delegate = [OCMockObject mockForProtocol:@protocol(KSStackOverflowManagerDelegate)];
  _underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
  _questionArray = @[[[KSQuestion alloc] init]];
  _questionJSON = @"{ \"fake\": \"json\" }";
  
  _questionBuilder = [[KSQuestionBuilderMock alloc] init];
  
  _mgr.delegate = _delegate;
  _mgr.questionBuilder = _questionBuilder;
}

- (void) tearDown
{
  _mgr = nil;
  _delegate = nil;
  _underlyingError = nil;
  _questionArray = nil;
  _questionJSON = nil;
  
  _questionBuilder = nil;
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
  [[_delegate stub] fetchingQuestionsFailedWithError:[OCMArg any]];
  
  [_mgr receivedQuestionJSON:_questionJSON];
  
  _mgr.questionBuilder = nil;
  
  STAssertEqualObjects(_questionBuilder.JSON, _questionJSON, @"Builder is called by manager");
}

- (void) testDelegateNotifiedOfErrorWhenQuestionBuilderFails
{
  _questionBuilder.errorToSet = _underlyingError;
  
  [[_delegate expect] fetchingQuestionsFailedWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [[obj userInfo] objectForKey:NSUnderlyingErrorKey] == _underlyingError;
  }]];
  
  [_mgr receivedQuestionJSON:_questionJSON];
  
  _mgr.questionBuilder = nil;
  
  [_delegate verify];
}

- (void) testDelegateNotToldAboutErrorWhenQuestionsReceived
{
  _questionBuilder.arrayToReturn = _questionArray;
  
  [[_delegate expect] didReceiveQuestions:[OCMArg any]];
  [_mgr receivedQuestionJSON:_questionJSON];
  
  [_delegate verify];
}

- (void) testDelegateReceivesTheQuestionsDiscoveredByManager
{
  _questionBuilder.arrayToReturn = _questionArray;
  
  [[_delegate expect] didReceiveQuestions:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[NSArray class]];
  }]];
  
  [_mgr receivedQuestionJSON:_questionJSON];
  
  [_delegate verify];
}

- (void) testEmptyArrayIsPassedToDelegate
{
  _questionBuilder.arrayToReturn = [NSArray array];
  
  [[_delegate expect] didReceiveQuestions:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[NSArray class]] && [obj count] == 0;
  }]];
  
  [_mgr receivedQuestionJSON:_questionJSON];
  
  [_delegate verify];
}

@end
