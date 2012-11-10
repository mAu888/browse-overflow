//
//  KSTopic.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSTopic.h"
#import "KSQuestion.h"

@implementation KSTopic
{
  NSArray *_questions;
}

@synthesize tag = _tag;
@synthesize name = _name;

- (id) initWithName:(NSString *)name tag:(NSString *)tag
{
  if ((self = [super init]) == nil)
    return nil;
  
  _tag = tag;
  _name = name;
  _questions = [[NSArray alloc] init];
  
  return self;
}

- (NSArray *) recentQuestions
{
  return _questions;
}

- (void) addQuestion:(KSQuestion *)question
{
  _questions = [_questions arrayByAddingObject:question];
  _questions = [self sortQuestionsLatestFirst:_questions];
  
  if ([_questions count] > 20)
    _questions = [_questions subarrayWithRange:NSMakeRange(0, 20)];
}

#pragma mark - Private methods

- (NSArray *) sortQuestionsLatestFirst:(NSArray *)questions
{
  return [questions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    KSQuestion *q1 = (KSQuestion *) obj1;
    KSQuestion *q2 = (KSQuestion *) obj2;
    
    return [q2.date compare:q1.date];
  }];
}

@end
