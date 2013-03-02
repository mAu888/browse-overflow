//
//  KSQuestionBuilderTests.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 11.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionBuilderTests.h"
#import "KSPerson.h"
#import "KSQuestion.h"

@implementation KSQuestionBuilderTests
{
  KSQuestionBuilder *_questionBuilder;
  KSQuestion *_question;
}


static NSString *questionJSON = @"{"
@"\"total\": 4533314,"
@"\"page\": 1,"
@"\"pagesize\": 1,"
@"\"questions\": ["
@"  {"
@"    \"tags\": ["
@"      \"html\","
@"      \"css\","
@"      \"file\""
@"    ],"
@"    \"answer_count\": 3,"
@"    \"favorite_count\": 0,"
@"    \"question_timeline_url\": \"/questions/15054027/timeline\","
@"    \"question_comments_url\": \"/questions/15054027/comments\","
@"    \"question_answers_url\": \"/questions/15054027/answers\","
@"    \"question_id\": 15054027,"
@"    \"owner\": {"
@"      \"user_id\": 2104881,"
@"      \"user_type\": \"registered\","
@"      \"display_name\": \"Aidan Dwyer\","
@"      \"reputation\": 1,"
@"      \"email_hash\": \"8a6050998e97e22b2dcbe9e25864d740\","
@"      \"profile_image\": \"http://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG\""
@"    },"
@"    \"creation_date\": 1361724582,"
@"    \"last_edit_date\": 1361724776,"
@"    \"last_activity_date\": 1361724943,"
@"    \"up_vote_count\": 0,"
@"    \"down_vote_count\": 1,"
@"    \"view_count\": 16,"
@"    \"score\": -1,"
@"    \"community_owned\": false,"
@"    \"title\": \"CSS style sheet not affecting my html file when I open it from my computer\","
@"    \"body\": \"<p>I am using datatables</p>\""
@"  }"
@"]"
@"}";

static NSString *noQuestionsJSON = @"{ \"questions\": [] }";

- (void) setUp
{
  _questionBuilder = [[KSQuestionBuilder alloc] init];
  _question = [[_questionBuilder questionsFromJSON:questionJSON error:NULL] objectAtIndex:0];
}

- (void) tearDown
{
  _questionBuilder = nil;
  _question = nil;
}

- (void) testThatNilIsNotAnAcceptableParameter
{
  STAssertThrows([_questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should have been handeled elsewhere");
}

- (void) testNilReturnedWhenStringIsNotJSON
{
  STAssertNil([_questionBuilder questionsFromJSON:@"some string" error:NULL], @"Question builder should not parse non-JSON values");
}

- (void) testErrorSetWhenStringIsNotJSON
{
  NSError *error = nil;
  [_questionBuilder questionsFromJSON:@"some string" error:&error];
  
  STAssertNotNil(error, @"Error should be available when string is not JSON");
}

- (void) testPassingNullErrorDoesNotCrash
{
  STAssertNoThrow([_questionBuilder questionsFromJSON:@"some string" error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void) testRealJSONWithoutQuestionsArrayIsError
{
  NSString *jsonString = @"{ \"noquestions\": true }";
  STAssertNil([_questionBuilder questionsFromJSON:jsonString error:NULL], @"Should not parse json without questions");
}

- (void) testRealJSONWithoutQuestionsReturnsMissingDataError
{
  NSString *jsonString = @"{ \"noquestions\": true }";
  
  NSError *error = nil;
  [_questionBuilder questionsFromJSON:jsonString error:&error];
  
  STAssertEquals([error code], KSQuestionBuilderMissingDataError, @"Empty json should return appropriate error");
}

- (void) testJSONWithOneQuestionReturnsOneQuestionObject
{
  NSError *error = nil;
  NSArray *questions = [_questionBuilder questionsFromJSON:questionJSON error:&error];
  STAssertEquals(questions.count, (NSUInteger)1, @"Question builder should return one question");
}

- (void) testQuestionCreatedFromJSONHasPropertiesPresentedInJSON
{
  STAssertEquals(_question.questionID, 15054027, @"The question id should match");
  STAssertEquals([_question.date timeIntervalSince1970], (NSTimeInterval)1361724582, @"The date should match");
  STAssertEqualObjects(_question.title, @"CSS style sheet not affecting my html file when I open it from my computer", @"The questions title should match");
  STAssertEquals(_question.score, -1, @"The score should match");
  
  KSPerson *person = _question.asker;
  STAssertEqualObjects(person.name, @"Aidan Dwyer", @"The asker name should match");
  STAssertEqualObjects(person.avatarURL, @"http://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG", @"The avatar url should match");
}

- (void) testBuildingQuestionWithNoDataCannotBeTried
{
  STAssertThrows([_questionBuilder fillInDetailsForQuestion:_question json:nil], @"Question with no data can not be created");
}

- (void) testBuildingQuestionsWithNoQuestionCannotBeTried
{
  STAssertThrows([_questionBuilder fillInDetailsForQuestion:nil json:@"Fake JSON"], @"Filling in data with no question is not possible");
}

- (void) testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion
{
  [_questionBuilder fillInDetailsForQuestion:_question json:@"Fake JSON"];
  STAssertNil(_question.body, @"Question has no body when received invalid JSON");
}

- (void) testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
  [_questionBuilder fillInDetailsForQuestion:_question json:noQuestionsJSON];
  STAssertNil(_question.body, @"No body to add");
}

- (void) testBodyContainedInJSONIsAddedToQuestion
{
  [_questionBuilder fillInDetailsForQuestion:_question json:questionJSON];
  STAssertEqualObjects(_question.body, @"<p>I am using datatables</p>", @"Correct question body should have been set");
}

@end
