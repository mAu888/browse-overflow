//
//  KSAnswerTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerTests.h"
#import "KSAnswer.h"
#import "KSPerson.h"

@implementation KSAnswerTests
{
  KSAnswer *_answer;
  KSAnswer *_otherAnswer;
  
  KSPerson *_sharedPerson;
  NSString *_sharedText;
  int _sharedScore;
}

#pragma mark - Set up & tear down

- (void) setUp
{
  _sharedText = @"The answer is 42";
  _sharedScore = 42;
  _sharedPerson = [[KSPerson alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
  
  _answer = [[KSAnswer alloc] init];
  _answer.text = _sharedText;
  _answer.score = _sharedScore;
  _answer.person = _sharedPerson;
  
  _otherAnswer = [[KSAnswer alloc] init];
  _otherAnswer.text = @"Second answer";
  _otherAnswer.score = 42;
}

- (void) tearDown
{
  _sharedText = nil;
  _sharedPerson = nil;
  _sharedScore = 0;
  
  _answer = nil;
  _otherAnswer = nil;
}

#pragma mark - The tests

- (void) testAnswerHasSomeText
{
  STAssertEquals(_answer.text, _sharedText, @"Answer should have a text");
}

- (void) testSomeoneProvidedTheAnswer
{
  STAssertTrue([_answer.person isKindOfClass:[KSPerson class]], @"A person gave this answer");
}

- (void) testAnswerShouldNotBeAcceptedByDefault
{
  STAssertFalse(_answer.isAccepted, @"Answer not accepted by default");
}

- (void) testAnswerCanBeAccepted
{
  STAssertNoThrow(_answer.accepted = YES, @"Answer can be accepted");
}

- (void) testAnswerHasAScore
{
  STAssertEquals(_answer.score, _sharedScore, @"Answer should have a score");
}

- (void) testAcceptedAnswerComesBeforeUnaccepted
{
  _otherAnswer.accepted = YES;
  _otherAnswer.score = _answer.score;
  
  STAssertEquals([_answer compare:_otherAnswer], NSOrderedDescending, @"Accepted answer should come first");
  STAssertEquals([_otherAnswer compare:_answer], NSOrderedAscending, @"Unaccepted answere should come last");
}

- (void) testAnswerWithEqualScoresCompareEqually
{
  STAssertEquals([_answer compare:_otherAnswer], NSOrderedSame, @"Both answers should rank same");
  STAssertEquals([_otherAnswer compare:_answer], NSOrderedSame, @"Both answers should rank same");
}

- (void) testLowerScoreAnswerComesAfterHigher
{
  _otherAnswer.score = _answer.score + 10;
  
  STAssertEquals([_answer compare:_otherAnswer], NSOrderedDescending, @"Lower score comes last");
  STAssertEquals([_otherAnswer compare:_answer], NSOrderedAscending, @"Higher score comes first");
}

@end
