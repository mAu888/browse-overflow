//
//  KSAnswerBuilder.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 02.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerBuilder.h"
#import "KSQuestion.h"

NSString * const KSAnswerBuilderErrorDomain = @"KSAnswerBuilderErrorDomain";

@implementation KSAnswerBuilder

- (NSArray *) addAnswersToQuestion:(KSQuestion *)question fromJSON:(NSString *)json error:(NSError *__autoreleasing *)error
{
  NSAssert(json != nil, @"Can not handle nil json");
  NSAssert(question != nil, @"Can not handle nil question");
  
  id jsonObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
  if (jsonObject == nil)
  {
    if (error != NULL)
      *error = [NSError errorWithDomain:KSAnswerBuilderErrorDomain code:KSAnswerBuilderInvalidJSONError userInfo:nil];
    
    return nil;
  }
  
  return nil;
}

@end
