//
//  KSQuestionTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionTests.h"
#import "KSQuestion.h"
#import "KSAnswer.h"

@implementation KSQuestionTests
{
  KSQuestion *_question;
  KSAnswer *_accepted;
  KSAnswer *_highScore;
  KSAnswer *_lowScore;
  
  NSString *_sharedTitle;
  NSDate *_sharedDate;
  int _sharedScore;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _sharedTitle = @"Do iPhones also dream of electric sheep?";
  _sharedDate = [NSDate distantPast];
  _sharedScore = 42;
  
  _question = [[KSQuestion alloc] init];
  _question.title = _sharedTitle;
  _question.date = _sharedDate;
  _question.score = _sharedScore;
  
  //////////
  // Answers
  _accepted = [[KSAnswer alloc] init];
  _accepted.accepted = YES;
  
  _highScore = [[KSAnswer alloc] init];
  _highScore.score = 11;
  
  _lowScore = [[KSAnswer alloc] init];
  _lowScore.score = -4;
  
  [_question addAnswer:_accepted];
  [_question addAnswer:_highScore];
  [_question addAnswer:_lowScore];
}

- (void) tearDown
{
  _sharedTitle = nil;
  _sharedDate = nil;
  _sharedScore = -1;
  
  _question = nil;
  
  _accepted = nil;
  _highScore = nil;
  _lowScore = nil;
}

#pragma mark - The tests

- (void) testQuestionHasADate
{
  STAssertEqualObjects(_question.date, _sharedDate, @"Question needs to provide its date");
}

- (void) testQuestionKeepScore
{
  STAssertEquals(_question.score, _sharedScore, @"Question needs a numeric score");
}

- (void) testQuestionHasATitle
{
  STAssertEqualObjects(_question.title, _sharedTitle, @"Question should know its title");
}

- (void) testQuestionCanHaveAnswerAdded
{
  KSAnswer *answer = [[KSAnswer alloc] init];
  STAssertNoThrow([_question addAnswer:answer], @"Answer can be added");
}

- (void) testAcceptedAnswerIsFirst
{
  KSAnswer *answer = [_question.answers objectAtIndex:0];
  STAssertTrue([answer isAccepted], @"First answer is accepted");
}

- (void) testHighScoredAnswerBeforeLow
{
  NSArray *answers = _question.answers;
  NSUInteger highIndex = [answers indexOfObject:_highScore];
  NSUInteger lowIndex = [answers indexOfObject:_lowScore];
  
  STAssertTrue(highIndex < lowIndex, @"Higher rated answer should come first");
}

@end
