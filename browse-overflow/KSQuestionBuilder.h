//
//  KSQuestionBuilder.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 10.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *KSQuestionBuilderErrorDomain;

@class KSQuestion;

enum {
  KSQuestionBuilderInvalidJSONError = 0,
  KSQuestionBuilderMissingDataError
};

@interface KSQuestionBuilder : NSObject

- (NSArray *) questionsFromJSON:(NSString *)objectNotation error:(NSError **)error;
- (void) fillInDetailsForQuestion:(KSQuestion *)question json:(NSString *)json;

@end
