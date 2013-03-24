//
//  KSStackOverflowCommunicator.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

@interface KSStackOverflowCommunicator ()

@end


static NSString *KSStackOverflowCommunicatorErrorDomain = @"KSStackOverflowErrorDomain";

@implementation KSStackOverflowCommunicator
{
  void (^errorHandler)(NSError *);
  void (^successHandler)(NSString *);
}

- (void) launchConnectionForRequest:(NSURLRequest *)request
{
  [self cancelAndDiscardURLConnection];
  _fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) fetchContentAtURL:(NSURL *)url errorHandler:(void(^)(NSError *error))errorBlock successHandler:(void(^)(NSString *responseString))successBlock
{
  _fetchingURL = url;
  
  errorHandler = [errorBlock copy];
  successHandler = [successBlock copy];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:_fetchingURL];
  [self launchConnectionForRequest:request];
}

- (void) searchForQuestionsWithTag:(NSString *)tag
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/search?tagged=%@&pagesize=20", tag];
  [self fetchContentAtURL:[NSURL URLWithString:urlString] errorHandler:^(NSError *error) {
    [_delegate searchingForQuestionsFailedWithError:error];
  } successHandler:^(NSString *responseString) {  
    [_delegate receivedQuestionJSON:responseString];
  }];
}

- (void) downloadInformationForQuestionWithID:(NSUInteger)identifier
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d?body=true", identifier];
  [self fetchContentAtURL:[NSURL URLWithString:urlString] errorHandler:^(NSError *error) {
    [_delegate fetchingQuestionBodyFailedWithError:error];
  } successHandler:^(NSString *responseString) {
    [_delegate receivedQuestionBodyJSON:responseString];
  }];
}

- (void) downloadAnswersToQuestionWithID:(NSUInteger)identifier
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d/answers?body=true", identifier];
  [self fetchContentAtURL:[NSURL URLWithString:urlString] errorHandler:^(NSError *error) {
    [_delegate fetchingAnswersFailedWithError:error];
  } successHandler:^(NSString *responseString) {
    [_delegate receivedAnswersJSON:responseString];
  }];
}

- (void) cancelAndDiscardURLConnection
{
  [_fetchingConnection cancel];
  _fetchingConnection = nil;
}


#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  _receivedData = [NSData data];
  
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode != 200)
  {
    NSError *error = [NSError errorWithDomain:KSStackOverflowCommunicatorErrorDomain code:httpResponse.statusCode userInfo:nil];
    errorHandler(error);
  }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  errorHandler(error);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSString *json = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
  successHandler(json);
}

@end
