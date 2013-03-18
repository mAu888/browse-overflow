//
//  KSAnswerBuilder.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 02.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerBuilder.h"
#import "KSAnswer.h"
#import "KSQuestion.h"
#import "KSPerson.h"
#import "KSPersonBuilder.h"

NSString * const KSAnswerBuilderErrorDomain = @"KSAnswerBuilderErrorDomain";

@implementation KSAnswerBuilder

- (BOOL) addAnswersToQuestion:(KSQuestion *)question fromJSON:(NSString *)json error:(NSError *__autoreleasing *)error
{
  NSAssert(json != nil, @"Can not handle nil json");
  NSAssert(question != nil, @"Can not handle nil question");
  
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
  if (jsonObject == nil)
  {
    if (error != NULL)
      *error = [NSError errorWithDomain:KSAnswerBuilderErrorDomain code:KSAnswerBuilderInvalidJSONError userInfo:nil];
    
    return NO;
  }
  
  NSArray *items = jsonObject[@"items"];
  if (items == nil)
  {
    if (error != NULL)
      *error = [NSError errorWithDomain:KSAnswerBuilderErrorDomain code:KSAnswerBuilderNoAnswersJSONError userInfo:nil];
    
    return NO;
  }
  
  for (NSDictionary *answerJSON in items)
  {
    KSAnswer *answer = [[KSAnswer alloc] init];
    answer.score = [answerJSON[@"score"] intValue];
    answer.accepted = [answerJSON[@"is_accepted"] boolValue];
    answer.person = [KSPersonBuilder personFromDictionary:answerJSON[@"owner"]];
    
    [question addAnswer:answer];
  }
  
  return YES;
}

@end
