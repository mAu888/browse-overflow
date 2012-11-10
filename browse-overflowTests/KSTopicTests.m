//
//  KSTopicTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSTopicTests.h"
#import "KSTopic.h"
#import "KSQuestion.h"

@implementation KSTopicTests
{
  KSTopic *_topic;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _topic = [[KSTopic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void) tearDown
{
  _topic = nil;
}

#pragma mark - The tests

- (void) testThatTopicExists
{
  STAssertNotNil(_topic, @"should be able to create a KSTopic instance");
}

- (void) testThatTopicCanBeNamed
{
  STAssertEqualObjects(_topic.name, @"iPhone", @"the KSTopic should have the name given to the initializer");
}

- (void) testThatTopicHasATag
{
  STAssertEqualObjects(_topic.tag, @"iphone", @"the KSTopic should have the tag given to the initializer");
}

- (void) testForAListOfQuestions
{
  STAssertTrue([[_topic recentQuestions] isKindOfClass:[NSArray class]], @"Topic should provide a list of recent questions");
}

- (void) testForInitiallyEmptyQuestionList
{
  STAssertEquals([[_topic recentQuestions] count], (NSUInteger) 0, @"Topic should not have any initial question");
}

- (void) testAddingAQuestionToTheList
{
  KSQuestion *question = [[KSQuestion alloc] init];
  [_topic addQuestion:question];
  STAssertEquals([[_topic recentQuestions] count], (NSUInteger) 1, @"Adding a question increases question count");
}

- (void) testQuestionsAreListedChronologically
{
  KSQuestion *q1 = [[KSQuestion alloc] init];
  q1.date = [NSDate distantPast];
  
  KSQuestion *q2 = [[KSQuestion alloc] init];
  q2.date = [NSDate distantFuture];
  
  [_topic addQuestion:q1];
  [_topic addQuestion:q2];
  
  NSArray *questions = [_topic recentQuestions];
  KSQuestion *listedFirst = [questions objectAtIndex:0];
  KSQuestion *listedSecond = [questions objectAtIndex:1];
  
  STAssertEquals([listedFirst.date laterDate:listedSecond.date], listedFirst.date, @"The later question should appear first");
}

- (void) testLimitOfTwentyQuestions
{
  KSQuestion *q;
  for (NSUInteger i = 0; i < 25; i++)
  {
    q = [[KSQuestion alloc] init];
    [_topic addQuestion:q];
  }

  STAssertTrue([[_topic recentQuestions] count] < 21, @"Topic should only return last 20 questions");
}

@end
