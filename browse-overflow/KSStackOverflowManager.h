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
  kKSStackOverflowManagerErrorQuestionSearchCode = 0,
  kKSStackOverflowManagerErrorLoadingAnswersCode = 1,
  kKSStackOverflowManagerErrorCreatingAnswersCode = 2
};

@class KSTopic;
@class KSAnswerBuilder;
@class KSQuestion;
@class KSQuestionBuilder;
@class KSStackOverflowCommunicator;


@protocol KSStackOverflowManagerDelegate <NSObject>

- (void) didReceiveQuestions:(NSArray *)questions;
- (void) fetchingQuestionsFailedWithError:(NSError *)error;

- (void) didReceiveAnswersForQuestion:(KSQuestion *)question;
- (void) fetchingAnswersFailedWithError:(NSError *)error;

@property (strong) NSError *fetchError;

@end


@interface KSStackOverflowManager : NSObject <KSStackOverflowCommunicatorDelegate>

- (void) fetchQuestionsOnTopic:(KSTopic *)topic;
- (void) fetchBodyForQuestion:(KSQuestion *)question;
- (void) fetchAnswersForQuestion:(KSQuestion *)question;

@property (nonatomic, strong) KSStackOverflowCommunicator *communicator;
@property (nonatomic, strong) KSAnswerBuilder *answerBuilder;
@property (nonatomic, strong) KSQuestionBuilder *questionBuilder;
@property (nonatomic, strong) KSQuestion *questionToFill;
@property (nonatomic, weak) id<KSStackOverflowManagerDelegate> delegate;

@end
