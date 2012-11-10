//
//  KSStackOverflowManager.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 05.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *KSStackOverflowManagerError;

enum {
  kKSStackOverflowManagerErrorQuestionSearchCode
};

@class KSTopic;
@class KSStackOverflowCommunicator;


@protocol KSStackOverflowManagerDelegate <NSObject>

- (void) fetchingQuestionsFailedWithError:(NSError *)error;

@property (strong) NSError *fetchError;

@end


@interface KSStackOverflowManager : NSObject

- (void) fetchQuestionsOnTopic:(KSTopic *)topic;
- (void) searchingForQuestionsFailedWithError:(NSError *)error;

@property (nonatomic, strong) KSStackOverflowCommunicator *communicator;
@property (nonatomic, weak) id<KSStackOverflowManagerDelegate> delegate;

@end
