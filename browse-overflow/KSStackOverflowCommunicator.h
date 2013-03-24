//
//  KSStackOverflowCommunicator.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 06.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSTopic;
@class KSQuestion;

@protocol KSStackOverflowCommunicatorDelegate <NSObject>

- (void) receivedQuestionJSON:(NSString *)json;
- (void) searchingForQuestionsFailedWithError:(NSError *)error;
- (void) fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void) receivedQuestionBodyJSON:(NSString *)json;
- (void) fetchingAnswersFailedWithError:(NSError *)error;
- (void) receivedAnswersJSON:(NSString *)json;
@end


@interface KSStackOverflowCommunicator : NSObject <NSURLConnectionDataDelegate>
{
  @protected
  NSURL *_fetchingURL;
  NSURLConnection *_fetchingConnection;
  
  NSData *_receivedData;
}

@property (nonatomic, weak) id<KSStackOverflowCommunicatorDelegate> delegate;

- (void) searchForQuestionsWithTag:(NSString *)tag;

- (void) downloadInformationForQuestionWithID:(NSUInteger)identifier;
- (void) downloadAnswersToQuestionWithID:(NSUInteger)identifier;

- (void) cancelAndDiscardURLConnection;

@end
