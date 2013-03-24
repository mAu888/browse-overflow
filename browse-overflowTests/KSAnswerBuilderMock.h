//
//  KSAnswerBuilderMock.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 24.03.13.
//  Copyright (c) 2013 Mauricio Hanika. All rights reserved.
//

#import "KSAnswerBuilder.h"

@class KSQuestion;

@interface KSAnswerBuilderMock : KSAnswerBuilder

@property (nonatomic, strong) NSString *JSON;
@property (nonatomic, strong) KSQuestion *questionToFillAnswersFor;
@property (nonatomic, strong) NSError *errorToSet;

@end
