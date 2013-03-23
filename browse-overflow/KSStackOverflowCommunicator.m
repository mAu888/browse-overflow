//
//  KSStackOverflowCommunicator.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

static NSString *KSStackOverflowCommunicatorErrorDomain = @"KSStackOverflowErrorDomain";

@implementation KSStackOverflowCommunicator

- (void) fetchContentAtURL:(NSURL *)url
{
  _fetchingURL = url;
  
  NSURLRequest *request = [NSURLRequest requestWithURL:_fetchingURL];
  
  [_fetchingConnection cancel];
  _fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) searchForQuestionsWithTag:(NSString *)tag
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/search?tagged=%@&pagesize=20", tag];
  [self fetchContentAtURL:[NSURL URLWithString:urlString]];
}

- (void) fetchBodyForQuestion:(KSQuestion *)question
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.asdf"];
  [self fetchContentAtURL:[NSURL URLWithString:urlString]];
}

- (void) downloadInformationForQuestionWithID:(NSUInteger)identifier
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d?body=true", identifier];
  [self fetchContentAtURL:[NSURL URLWithString:urlString]];
}

- (void) downloadAnswersToQuestionWithID:(NSUInteger)identifier
{
  NSString *urlString = [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d/answers?body=true", identifier];
  [self fetchContentAtURL:[NSURL URLWithString:urlString]];
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
    if (_delegate != nil && [_delegate respondsToSelector:@selector(searchingForQuestionsFailedWithError:)])
    {
      NSError *error = [NSError errorWithDomain:KSStackOverflowCommunicatorErrorDomain code:httpResponse.statusCode userInfo:nil];
      [_delegate searchingForQuestionsFailedWithError:error];
    }
  }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  if (_delegate != nil && [_delegate respondsToSelector:@selector(searchingForQuestionsFailedWithError:)])
  {
    [_delegate searchingForQuestionsFailedWithError:error];
  }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  if (_delegate != nil && [_delegate respondsToSelector:@selector(receivedQuestionsJSON:)])
  {
    NSString *json = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    [_delegate receivedQuestionsJSON:json];
  }
}

@end
