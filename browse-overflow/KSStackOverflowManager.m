//
//  KSStackOverflowManager.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowManager.h"
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

@synthesize communicator = _communicator;
@synthesize questionBuilder = _questionBuilder;
@synthesize delegate = _delegate;

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

- (void) fetchBodyForQuestion:(KSQuestion *)question {
  self.questionToFill = question;
  [self.communicator downloadInformationForQuestionWithID:question.questionID];
}

- (void) searchingForQuestionsFailedWithError:(NSError *)error
{
  [self notifyDelegateAboutQuestionSearchError:error];
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
