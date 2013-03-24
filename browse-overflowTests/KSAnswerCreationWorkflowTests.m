//
//  KSAnswerCreationWorkflowTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 24.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerCreationWorkflowTests.h"
#import "KSStackOverflowManager.h"
#import "KSStackOverflowCommunicator.h"

#import "KSAnswerBuilderMock.h"
#import "KSAnswer.h"
#import "KSQuestion.h"

#import "OCMock.h"
#import "OCMockObject.h"
#import "OCMConstraint.h"

@implementation KSAnswerCreationWorkflowTests
{
  @private
  KSStackOverflowManager *_mgr;
  KSQuestion *_question;
  NSString *_answersJSON;
  NSArray *_answersArray;
  KSAnswerBuilderMock *_answerBuilder;
  
  NSError *_underlyingError;
  
  id _delegate;
}

- (void) setUp
{
  _mgr = [[KSStackOverflowManager alloc] init];
  _delegate = [OCMockObject niceMockForProtocol:@protocol(KSStackOverflowManagerDelegate)];
  _answersJSON = @"{ \"fake\": \"json\" }";
  _answersArray = @[[[KSAnswer alloc] init]];
  _answerBuilder = [[KSAnswerBuilderMock alloc] init];
  
  _mgr.answerBuilder = _answerBuilder;
  _mgr.delegate = _delegate;
  
  _question = [[KSQuestion alloc] init];
  _question.questionID = 12345;
  
  _underlyingError = [NSError errorWithDomain:@"Test domain" code:12345 userInfo:nil];
}

- (void) tearDown
{
  _mgr = nil;
  _delegate = nil;
  _answersJSON = nil;
  _answersArray = nil;
  _answerBuilder = nil;
  
  _question = nil;
  _underlyingError = nil;
}

- (void) testAskingForAnswersRequiresQuestion
{
  STAssertThrows([_mgr fetchAnswersForQuestion:nil], @"Fetching answers requires existing question");
}

- (void) testAskingForAnswersMeansFetchingData
{
  id comm = [OCMockObject mockForClass:[KSStackOverflowCommunicator class]];
  [[comm expect] downloadAnswersToQuestionWithID:12345];

  _mgr.communicator = comm;
  [_mgr fetchAnswersForQuestion:_question];
  
  [comm verify];
}

- (void) testErrorReturnedToDelegateIsNotErrorPassedToManager
{
  _mgr.delegate = _delegate;
  
  [[_delegate expect] fetchingAnswersFailedWithError:[OCMArg checkWithBlock:^BOOL(id arg) {
    return [arg isKindOfClass:[NSError class]] && [[arg domain] isEqualToString:KSStackOverflowManagerError];
  }]];
  
  [_mgr fetchingAnswersFailedWithError:_underlyingError];
  
  [_delegate verify];
}

- (void) testAnswersJSONIsPassedToAnswerBuilder
{
  [_mgr receivedAnswersJSON:_answersJSON];
  _mgr.answerBuilder = nil;
  
  STAssertEqualObjects(_answerBuilder.JSON, @"{ \"fake\": \"json\" }", @"JSON should have been passed to the answer builder");
}

- (void) testQuestionToFillAnswersIsPassedToAnswerBuilder
{
  [_mgr fetchAnswersForQuestion:_question];
  [_mgr receivedAnswersJSON:nil];
  
  STAssertEquals(_answerBuilder.questionToFillAnswersFor, _question, @"The question should have been passed to the answer builder");
}

- (void) testFailingToFillAnswersReportsErrorToDelegate
{
  _answerBuilder.errorToSet = _underlyingError;
  
  [[_delegate expect] fetchingAnswersFailedWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[NSError class]] && [[obj domain] isEqualToString:KSStackOverflowManagerError];
  }]];
  
  [_mgr fetchAnswersForQuestion:_question];
  [_mgr receivedAnswersJSON:nil];
  
  [_delegate verify];
}

- (void) testErrorReturnedToDelegateDocumentsUnderlyingError
{
  _answerBuilder.errorToSet = _underlyingError;
  
  [[_delegate expect] fetchingAnswersFailedWithError:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[NSError class]] && [obj userInfo][NSUnderlyingErrorKey] == _underlyingError;
  }]];
  
  [_mgr fetchAnswersForQuestion:_question];
  [_mgr receivedAnswersJSON:nil];
  
  [_delegate verify];
}

- (void) testManagerNotifiesDelegateAboutSuccessfulFetchingAnswers
{
  _answerBuilder.answersToSet = _answersArray;
  
  [[_delegate expect] didReceiveAnswersForQuestion:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == _question && _question.answers.count == _answersArray.count;
  }]];
  
  [_mgr fetchAnswersForQuestion:_question];
  [_mgr receivedAnswersJSON:nil];
  
  [_delegate verify];
}

- (void) testManagerResetsQuestionToFillAfterAnswersHaveBeenSet
{
  _answerBuilder.answersToSet = _answersArray;
  
  [_mgr fetchAnswersForQuestion:_question];
  [_mgr receivedAnswersJSON:nil];
  
  STAssertNil(_mgr.questionToFill, @"The question to fill should have been resetted");
}

@end
