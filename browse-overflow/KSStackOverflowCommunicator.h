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

@optional
- (void) receivedQuestionsJSON:(NSString *)json;
- (void) searchingForQuestionsFailedWithError:(NSError *)error;

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
- (void) fetchBodyForQuestion:(KSQuestion *)question;

- (void) downloadInformationForQuestionWithID:(NSUInteger)identifier;
- (void) downloadAnswersToQuestionWithID:(NSUInteger)identifier;

- (void) cancelAndDiscardURLConnection;

@end
