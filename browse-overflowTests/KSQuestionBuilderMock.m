//
//  KSQuestionBuilderMock.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 11.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionBuilderMock.h"
#import "KSQuestion.h"

@implementation KSQuestionBuilderMock

- (NSArray *) questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
{
  _JSON = objectNotation;
  *error = _errorToSet;
  return _arrayToReturn;
}

- (void) fillInDetailsForQuestion:(KSQuestion *)question json:(NSString *)json
{
  _JSON = json;
  _questionToFill = question;
}

@end
