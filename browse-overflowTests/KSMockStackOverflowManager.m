//
//  KSMockStackOverflowManager.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 21.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSMockStackOverflowManager.h"

@implementation KSMockStackOverflowManager
{
  NSUInteger _topicFailureErrorCode;
  NSString *_topicSearchString;
  NSUInteger _questionBodyFailureErrorCode;
  NSString *_questionBodyString;
  NSUInteger _answerFailureErrorCode;
  NSString *_answersString;
}

- (NSUInteger) topicFailureErrorCode
{
  return _topicFailureErrorCode;
}

- (NSString *) topicSearchString
{
  return _topicSearchString;
}

- (NSUInteger) questionBodyFailureErrorCode
{
  return _questionBodyFailureErrorCode;
}

- (NSString *) questionBodyString
{
  return _questionBodyString;
}

- (NSUInteger) answersFailureErrorCode
{
  return _answerFailureErrorCode;
}

- (NSString *) answersString
{
  return _answersString;
}


#pragma mark -
#pragma mark KSStackOverflowCommunicatorDelegate

- (void) searchingForQuestionsFailedWithError:(NSError *)error
{
  _topicFailureErrorCode = error.code;
}

- (void) receivedQuestionJSON:(NSString *)json
{
  _topicSearchString = json;
}

- (void) fetchingQuestionBodyFailedWithError:(NSError *)error
{
  _questionBodyFailureErrorCode = error.code;
}

- (void) receivedQuestionBodyJSON:(NSString *)json
{
  _questionBodyString = json;
}

- (void) fetchingAnswersFailedWithError:(NSError *)error
{
  _answerFailureErrorCode = error.code;
}

- (void) receivedAnswersJSON:(NSString *)json
{
  _answersString = json;
}

@end
