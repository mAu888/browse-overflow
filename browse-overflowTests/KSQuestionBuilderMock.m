//
//  KSQuestionBuilderMock.m
//  browse-overflow
//
//  Created by Mauricio Hanika on 11.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSQuestionBuilderMock.h"

@implementation KSQuestionBuilderMock

@synthesize JSON = _JSON;
@synthesize arrayToReturn = _arrayToReturn;
@synthesize errorToSet = _errorToSet;

- (NSArray *) questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
{
  _JSON = objectNotation;
  *error = _errorToSet;
  return _arrayToReturn;
}

@end
