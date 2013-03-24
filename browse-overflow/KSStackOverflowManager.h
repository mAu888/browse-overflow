//
//  KSStackOverflowManager.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import "KSStackOverflowCommunicator.h"

extern NSString *KSStackOverflowManagerError;

enum {
  kKSStackOverflowManagerErrorQuestionSearchCode = 0
};

@class KSTopic;
@class KSQuestion;
@class KSQuestionBuilder;
@class KSStackOverflowCommunicator;


@protocol KSStackOverflowManagerDelegate <NSObject>

- (void) didReceiveQuestions:(NSArray *)questions;
- (void) fetchingQuestionsFailedWithError:(NSError *)error;

@property (strong) NSError *fetchError;

@end


@interface KSStackOverflowManager : NSObject <KSStackOverflowCommunicatorDelegate>

- (void) fetchQuestionsOnTopic:(KSTopic *)topic;
- (void) fetchBodyForQuestion:(KSQuestion *)question;

@property (nonatomic, strong) KSStackOverflowCommunicator *communicator;
@property (nonatomic, strong) KSQuestionBuilder *questionBuilder;
@property (nonatomic, strong) KSQuestion *questionToFill;
@property (nonatomic, weak) id<KSStackOverflowManagerDelegate> delegate;

@end
