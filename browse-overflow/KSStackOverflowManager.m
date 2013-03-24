//
//  KSStackOverflowManager.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowManager.h"
#import "KSAnswerBuilder.h"
#import "KSQuestionBuilder.h"
#import "KSQuestion.h"
#import "KSTopic.h"

NSString *KSStackOverflowManagerError = @"KSStackOverflowManagerError";

@interface KSStackOverflowManager ()

- (void) notifyDelegateAboutQuestionSearchError:(NSError *)underlyingError;

@end


///////////////////
// Implementation

@implementation KSStackOverflowManager

- (void) setDelegate:(id<KSStackOverflowManagerDelegate>)delegate
{
  if (delegate != nil && ! [delegate conformsToProtocol:@protocol(KSStackOverflowManagerDelegate)])
  {
    [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil] raise];
  }
  
  _delegate = delegate;
}

- (void) fetchQuestionsOnTopic:(KSTopic *)topic
{
  [self.communicator searchForQuestionsWithTag:[topic tag]];
}

- (void) fetchBodyForQuestion:(KSQuestion *)question
{
  self.questionToFill = question;
  [self.communicator downloadInformationForQuestionWithID:question.questionID];
}

- (void) fetchAnswersForQuestion:(KSQuestion *)question
{
  NSAssert(question != nil, @"Can not fetch answers to no question");
  
  self.questionToFill = question;
  [self.communicator downloadAnswersToQuestionWithID:question.questionID];
}

- (void) searchingForQuestionsFailedWithError:(NSError *)error
{
  [self notifyDelegateAboutQuestionSearchError:error];
}

- (void) fetchingAnswersFailedWithError:(NSError *)underlyingError
{
  NSDictionary *userInfo = nil;
  if (underlyingError != nil) {
    userInfo = @{ NSUnderlyingErrorKey: underlyingError };
  }
  
  NSError *error = [NSError errorWithDomain:KSStackOverflowManagerError code:kKSStackOverflowManagerErrorLoadingAnswersCode userInfo:userInfo];
  [_delegate fetchingAnswersFailedWithError:error];
}

- (void) receivedQuestionJSON:(NSString *)objectNotation
{
  NSError *error = nil;
  NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
  
  if (questions == nil)
  {
    [self notifyDelegateAboutQuestionSearchError:error];
  }
  else
  {
    [_delegate didReceiveQuestions:questions];
  }
}

- (void) receivedQuestionBodyJSON:(NSString *)json
{
  [_questionBuilder fillInDetailsForQuestion:self.questionToFill json:json];
}

- (void) receivedAnswersJSON:(NSString *)json
{
  NSError *underlyingError = nil;
  if ([_answerBuilder addAnswersToQuestion:self.questionToFill fromJSON:json error:&underlyingError])
  {
    
  }
  else
  {
    NSError *error = [NSError errorWithDomain:KSStackOverflowManagerError
                                         code:kKSStackOverflowManagerErrorCreatingAnswersCode
                                     userInfo:@{ NSUnderlyingErrorKey: underlyingError }];
    [_delegate fetchingAnswersFailedWithError:error];
  }
}

- (void) fetchingQuestionBodyFailedWithError:(NSError *)error
{
  if (_delegate != nil && [_delegate respondsToSelector:@selector(setFetchError:)])
    [_delegate setFetchError:error];
}

#pragma mark -
#pragma mark Private methods

- (void) notifyDelegateAboutQuestionSearchError:(NSError *)underlyingError
{
  NSDictionary *errorInfo = nil;
  if (underlyingError != nil)
  {
    errorInfo = @{ NSUnderlyingErrorKey: underlyingError };
  }
  
  NSError *reportableError = [NSError errorWithDomain:KSStackOverflowManagerError code:kKSStackOverflowManagerErrorQuestionSearchCode userInfo:errorInfo];
  
  [_delegate fetchingQuestionsFailedWithError:reportableError];
}

@end
