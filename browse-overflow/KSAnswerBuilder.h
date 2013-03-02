//
//  KSAnswerBuilder.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 02.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KSAnswerBuilderErrorDomain;

NS_ENUM(int, KSAnswerBuilderError) {
  KSAnswerBuilderInvalidJSONError = 0
};

@class KSQuestion;

@interface KSAnswerBuilder : NSObject

- (NSArray *) addAnswersToQuestion:(KSQuestion *)question fromJSON:(NSString *)json error:(NSError **)error;

@end
