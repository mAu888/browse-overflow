//
//  KSQuestionBuilderMock.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 11.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSQuestionBuilder.h"

@interface KSQuestionBuilderMock : KSQuestionBuilder

@property (strong) NSString *JSON;
@property (strong) NSArray *arrayToReturn;
@property (strong) NSError *errorToSet;

@end
