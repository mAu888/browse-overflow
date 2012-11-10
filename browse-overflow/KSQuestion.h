//
//  KSQuestion.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSAnswer;

@interface KSQuestion : NSObject

- (void) addAnswer:(KSAnswer *)answer;

@property (nonatomic) NSArray *answers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int score;

@end
