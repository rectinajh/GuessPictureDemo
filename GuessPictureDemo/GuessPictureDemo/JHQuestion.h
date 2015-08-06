//
//  JHQuestion.h
//  GuessPictureDemo
//
//  Created by jh on 15/8/6.
//  Copyright © 2015年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHQuestion : NSObject

@property(nonatomic, copy)NSString *answer;
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)NSArray   *options;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)QuestionWithDict:(NSDictionary *)dict;




@end
