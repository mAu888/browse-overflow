//
//  KSQuestionBuilder.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 10.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionBuilder.h"
#import "KSQuestion.h"
#import "KSPerson.h"

NSString *KSQuestionBuilderErrorDomain = @"KSQuestionBuilderErrorDomain";

@implementation KSQuestionBuilder

- (NSArray *) questionsFromJSON:(NSString *)objectNotation error:(NSError **)error
{
  NSParameterAssert(objectNotation != nil);
  
  NSData *jsonData = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *jsonError = nil;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
  
  if (jsonObject == nil)
  {
    if (error != NULL)
    {
      *error = [NSError errorWithDomain:KSQuestionBuilderErrorDomain code:KSQuestionBuilderInvalidJSONError userInfo:nil];
    }
    
    return nil;
  }
  
  NSArray *questionsObject = jsonObject[@"questions"];
  if (questionsObject == nil)
  {
    if (error != NULL)
    {
      *error = [NSError errorWithDomain:KSQuestionBuilderErrorDomain code:KSQuestionBuilderMissingDataError userInfo:nil];
    }
    
    return nil;
  }
  
  NSMutableArray *questions = [NSMutableArray array];
  for (NSDictionary *questionObject in questionsObject)
  {
    KSQuestion *question = [[KSQuestion alloc] init];
    question.questionID = [questionObject[@"question_id"] intValue];
    question.title = questionObject[@"title"];
    question.score = [questionObject[@"score"] intValue];
    question.date = [NSDate dateWithTimeIntervalSince1970:[questionObject[@"creation_date"] intValue]];
    
    question.asker = [[KSPerson alloc] init];
    question.asker.name = questionObject[@"owner"][@"display_name"];
    question.asker.avatarURL = questionObject[@"owner"][@"profile_image"];
    
    [questions addObject:question];
  }
  
  return [NSArray arrayWithArray:questions];
}

- (void) fillInDetailsForQuestion:(KSQuestion *)question json:(NSString *)json
{
  NSAssert(json != nil, @"JSON may not be nil");
  NSAssert(question != nil, @"Filling data with no question is not possible");
  
  NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
  if (! [parsedJSON isKindOfClass:[NSDictionary class]])
    return;
  
  question.body = [parsedJSON[@"questions"] lastObject][@"body"];
}

@end
