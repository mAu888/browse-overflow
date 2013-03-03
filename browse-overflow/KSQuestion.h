//
//  KSQuestion.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSAnswer;
@class KSPerson;

@interface KSQuestion : NSObject

- (void) addAnswer:(KSAnswer *)answer;

@property (nonatomic, readonly) NSArray *answers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) KSPerson *asker;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int questionID;
@property (nonatomic, strong) NSString *body;

@end
