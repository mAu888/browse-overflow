//
//  KSTopic.h
//  browse-overflow
//
//  Created by Mauricio Hanika on 03.11.12.
//  Copyright (c) 2012 Mauricio Hanika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSQuestion;

@interface KSTopic : NSObject

- (id) initWithName:(NSString *)name tag:(NSString *)tag;

- (NSArray *) recentQuestions;
- (void) addQuestion:(KSQuestion *)quesiton;

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *tag;

@end
