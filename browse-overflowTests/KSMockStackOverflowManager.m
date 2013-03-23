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
  NSUInteger *_topicFailureErrorCode;
  NSString *_topicSearchString;
}

- (NSUInteger) topicFailureErrorCode
{
  return _topicFailureErrorCode;
}

- (NSString *)topicSearchString
{
  return _topicSearchString;
}

- (void) searchingForQuestionsFailedWithError:(NSError *)error
{
  _topicFailureErrorCode = [error code];
}

- (void) receivedQuestionsJSON:(NSString *)json
{
  _topicSearchString = json;
}

@end
