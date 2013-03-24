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
#import "KSAnswer.h"
#import "KSPerson.h"

@implementation KSAnswerBuilderTests
{
  KSAnswerBuilder *_answerBuilder;
  KSQuestion *_question;
}

static NSString *answersJSON = @"{"
@"\"items\": ["
@"  {"
@"    \"question_id\": 15054027,"
@"    \"answer_id\": 15054632,"
@"    \"creation_date\": 1361728231,"
@"    \"last_activity_date\": 1361728231,"
@"    \"score\": 0,"
@"    \"is_accepted\": false,"
@"    \"owner\": {"
@"      \"user_id\": 1273604,"
@"      \"display_name\": \"Sandeep Nayak\","
@"      \"reputation\": 1,"
@"      \"user_type\": \"registered\","
@"      \"profile_image\": \"http://www.gravatar.com/avatar/d9970942c9ea0e69863b20d1dba448d0?d=identicon&r=PG\","
@"      \"link\": \"http://stackoverflow.com/users/1273604/sandeep-nayak\""
@"    }"
@"  },"
@"  {"
@"    \"question_id\": 15054027,"
@"    \"answer_id\": 15054220,"
@"    \"creation_date\": 1361725850,"
@"    \"last_activity_date\": 1361725850,"
@"    \"score\": 0,"
@"    \"is_accepted\": false,"
@"   \"owner\": {"
@"      \"user_id\": 1248166,"
@"      \"display_name\": \"Mario Vlad\","
@"      \"reputation\": 313,"
@"      \"user_type\": \"registered\","
@"      \"profile_image\": \"http://i.stack.imgur.com/JeOqM.jpg?g=1&s=128\","
@"      \"link\": \"http://stackoverflow.com/users/1248166/mario-vlad\""
@"    }"
@"  },"
@"  {"
@"    \"question_id\": 15054027,"
@"    \"answer_id\": 15054066,"
@"    \"creation_date\": 1361724931,"
@"    \"last_activity_date\": 1361724931,"
@"    \"score\": 1,"
@"    \"is_accepted\": true,"
@"    \"owner\": {"
@"      \"user_id\": 1554215,"
@"      \"display_name\": \"mavrosxristoforos\","
@"     \"reputation\": 538,"
@"      \"user_type\": \"registered\","
@"      \"profile_image\": \"http://i.stack.imgur.com/3W2he.jpg?g=1&s=128\","
@"      \"link\": \"http://stackoverflow.com/users/1554215/mavrosxristoforos\""
@"    }"
@"  }"
@"],"
@"\"quota_remaining\": 9967,"
@"\"quota_max\": 10000,"
@"\"has_more\": false"
@"}";

static NSString *noAnswersJSON = @"{"
@"  \"noanswers\": true"
@"}";

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

- (void) testSendingInvalidJSONReturnsAppropriateError
{
  NSError *error = nil;
  [_answerBuilder addAnswersToQuestion:_question fromJSON:@"invalid JSON" error:&error];
  
  STAssertEqualObjects(error.domain, KSAnswerBuilderErrorDomain, @"Appropriate error domain returned when invalid json passed");
  STAssertEquals(error.code, KSAnswerBuilderInvalidJSONError, @"Appropriate error code set when invalid json passed");
}

- (void) testSendingJSONWithInvalidKeysIsAnError
{
  NSError *error = nil;
  STAssertFalse([_answerBuilder addAnswersToQuestion:_question fromJSON:noAnswersJSON error:&error], @"JSON without answers returns error");
}

- (void) testAddingJSONWithRealAnswerIsNotAnError
{
  STAssertTrue([_answerBuilder addAnswersToQuestion:_question fromJSON:answersJSON error:NULL], @"Should add answers to question");
}

- (void) testNumberOfAnswersIsEqualToAnswersReturnedInJSON
{
  [_answerBuilder addAnswersToQuestion:_question fromJSON:answersJSON error:NULL];
  STAssertEquals(_question.answers.count, (NSUInteger)3, @"Number of answers equals answers returned in json");
}

- (void) testAnswerIsFilledWithCorrectDataFromJSON
{
  [_answerBuilder addAnswersToQuestion:_question fromJSON:answersJSON error:NULL];
  
  KSAnswer *answer = _question.answers[0];
  STAssertTrue(answer.isAccepted, @"Answer is not accepted");
  STAssertEquals(answer.score, (int)1, @"Score should equal");
}

- (void) testAnswerAuthorPersonObjectIsFilledProperly
{
  [_answerBuilder addAnswersToQuestion:_question fromJSON:answersJSON error:NULL];
//  @"    \"owner\": {"
//  @"      \"user_id\": 1554215,"
//  @"      \"display_name\": \"mavrosxristoforos\","
//  @"     \"reputation\": 538,"
//  @"      \"user_type\": \"registered\","
//  @"      \"profile_image\": \"http://i.stack.imgur.com/3W2he.jpg?g=1&s=128\","
//  @"      \"link\": \"http://stackoverflow.com/users/1554215/mavrosxristoforos\""
//  @"    }"
  KSPerson *person = [_question.answers[0] person];
  STAssertEqualObjects(person.name, @"mavrosxristoforos", @"Name should match");
  STAssertEqualObjects(person.avatarURL, [NSURL URLWithString:@"http://i.stack.imgur.com/3W2he.jpg?g=1&s=128"], @"Avatar url should match");
}

@end
