//
//  KSAnswerBuilderTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 02.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerBuilderTests.h"
#import "KSAnswerBuilder.h"
#import "KSQuestion.h"

@implementation KSAnswerBuilderTests
{
  KSAnswerBuilder *_answerBuilder;
  KSQuestion *_question;
}


- (void) setUp
{
  _answerBuilder = [[KSAnswerBuilder alloc] init];
  _question = [[KSQuestion alloc] init];
}

- (void) tearDown
{
  _answerBuilder = nil;
  _question = nil;
}

////////////////////////////////////////////////////////////////////////////////
// Tests

- (void) testNilIsNotAnAcceptableJSONParameter
{
  STAssertThrows([_answerBuilder addAnswersToQuestion:_question fromJSON:nil error:NULL], @"Passing nil as json should throw");
}

- (void) testAddingAnswersToNilQuestionThrows
{
  STAssertThrows([_answerBuilder addAnswersToQuestion:nil fromJSON:@"{ \"answers\": [] }" error:NULL], @"Nil is not an acceptable question");
}

- (void) testPassingNullAsErrorIsAcceptable
{
  STAssertNoThrow([_answerBuilder addAnswersToQuestion:_question fromJSON:@"invalid JSON" error:NULL], @"Passing null is acceptable");
}

- (void) testSendingInvalidJSONReturnsAppripriateError
{
  NSError *error = nil;
  [_answerBuilder addAnswersToQuestion:_question fromJSON:@"invalid JSON" error:&error];
  
  STAssertEqualObjects(error.domain, KSAnswerBuilderErrorDomain, @"Appropriate error domain returned when invalid json passed");
  STAssertEquals(error.code, KSAnswerBuilderInvalidJSONError, @"Appropriate error code set when invalid json passed");
}

@end
