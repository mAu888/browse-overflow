//
//  KSStackOverflowCommunicatorTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 18.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicatorTests.h"
#import "KSInspectableStackOverflowCommunicator.h"
#import "KSMockStackOverflowManager.h"
#import "KSNonNetworkedStackOverflowCommunicator.h"
#import "KSFakeURLResponse.h"
#import "KSQuestion.h"

@implementation KSStackOverflowCommunicatorTests
{
  KSInspectableStackOverflowCommunicator *_communicator;
  KSNonNetworkedStackOverflowCommunicator *_nnCommunicator;
  KSMockStackOverflowManager *_manager;
  
  KSFakeURLResponse *_fourOhFourResponse;
  NSData *_receivedData;
}

- (void) setUp
{
  _communicator = [[KSInspectableStackOverflowCommunicator alloc] init];
  _nnCommunicator = [[KSNonNetworkedStackOverflowCommunicator alloc] init];
  
  _manager = [[KSMockStackOverflowManager alloc] init];
  _nnCommunicator.delegate = _manager;
  
  _fourOhFourResponse = [[KSFakeURLResponse alloc] initWithStatusCode:404];
  _receivedData = [@"Result" dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) tearDown
{
  [_communicator cancelAndDiscardURLConnection];
  
  _communicator = nil;
  _nnCommunicator = nil;
  _manager = nil;
  _fourOhFourResponse = nil;
  _receivedData = nil;
}

- (void) testSearchingForQuestionsOnTopicCallsTopicAPI
{
  [_communicator searchForQuestionsWithTag:@"ios"];
  
  STAssertEqualObjects([[_communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/search?tagged=ios&pagesize=20", @"Use the search api to find questions for a particular tag");
}

- (void) testFillingInQuestionBodyCallsQuestionAPI
{
  [_communicator downloadInformationForQuestionWithID:12345];
  
  STAssertEqualObjects([[_communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345?body=true", @"Use the question API to get the body for a question");
}

- (void) testFetchingAnswersToQuestionCallsQuestionAPI
{
  [_communicator downloadAnswersToQuestionWithID:12345];
  
  STAssertEqualObjects([[_communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345/answers?body=true", @"Use the question API to get answers on a given question");
}

- (void) testSearchingForQuestionsCrestesURLConnection
{
  [_communicator searchForQuestionsWithTag:@"ios"];
  
  STAssertNotNil([_communicator currentURLConnection], @"There should be an active URL connection");
  [_communicator cancelAndDiscardURLConnection];
}

- (void) testStartingNewSearchThrowsOutOldConnection
{
  [_communicator searchForQuestionsWithTag:@"ios"];
  
  NSURLConnection *firstConnection = [_communicator currentURLConnection];
  [_communicator searchForQuestionsWithTag:@"android"];
  
  NSURLConnection *secondConnection = [_communicator currentURLConnection];
  STAssertFalse([secondConnection isEqual:firstConnection], @"A new connection should have been created");
  
  [_communicator cancelAndDiscardURLConnection];
}

- (void) testFetchingAnswersToQuestionCreatesURLConnection
{
  [_communicator downloadAnswersToQuestionWithID:12345];
  
  STAssertNotNil([_communicator currentURLConnection], @"An URL connection should have been created for fetching the answers");
  [_communicator cancelAndDiscardURLConnection];
}

- (void) testFetchingQuestionBodyCreatesURLConnection
{
  KSQuestion *question = [[KSQuestion alloc] init];
  [_communicator fetchBodyForQuestion:question];
  STAssertNotNil([_communicator currentURLConnection], @"There should be a URL connection running for fetching the questions body");
  
  [_communicator cancelAndDiscardURLConnection];
}

- (void) testReceivingResponseDiscardsExistingData
{
  _nnCommunicator.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
  [_nnCommunicator searchForQuestionsWithTag:@"ios"];
  [_nnCommunicator connection:nil didReceiveResponse:nil];
  
  STAssertEquals(_nnCommunicator.receivedData.length, (NSUInteger)0, @"Existing data should have been discarded");
}

- (void) testReceivingResponseWith404StatusPassesErrorToDelegate
{
  [_nnCommunicator searchForQuestionsWithTag:@"ios"];
  [_nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)_fourOhFourResponse];
  
  STAssertEquals([_manager topicFailureErrorCode], (NSUInteger)404, @"Fetch failure was passed through to delegate");
}

- (void) testNoErrorReceivedOn200Status
{
  KSFakeURLResponse *twoHundredResponse = [[KSFakeURLResponse alloc] initWithStatusCode:200];
  [_nnCommunicator searchForQuestionsWithTag:@"ios"];
  [_nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)twoHundredResponse];
  
  STAssertFalse([_manager topicFailureErrorCode] == 200, @"200er should not been handled as an error");
}

- (void) testConnectionFailingPassesErrorToDelegate
{
  [_nnCommunicator searchForQuestionsWithTag:@"ios"];
  NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
  [_nnCommunicator connection:nil didFailWithError:error];
  
  STAssertEquals([_manager topicFailureErrorCode], (NSUInteger)12345, @"Failing error should get passed to delegate");
}

- (void) testSuccessfulQuestionSearchPassesDataToDelegate
{
  [_nnCommunicator searchForQuestionsWithTag:@"ios"];
  [_nnCommunicator setReceivedData:_receivedData];
  [_nnCommunicator connectionDidFinishLoading:nil];
  
  STAssertEqualObjects([_manager topicSearchString], @"Result", @"The delegate should have received data on success");
}

@end
