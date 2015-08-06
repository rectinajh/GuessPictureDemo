//
//  JHQuestion.m
//  GuessPictureDemo
//
//  Created by jh on 15/8/6.
//  Copyright © 2015年 jh. All rights reserved.
//

#import "JHQuestion.h"

@implementation JHQuestion

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _answer = dict[@"answer"];
        _title = dict[@"title"];
        _icon =dict[@"icon"];
        _options = dict[@"options"];
        
    }
    return self;

}

+ (instancetype)QuestionWithDict:(NSDictionary *)dict
{
    
    return [[self alloc]initWithDict:dict];

}


@end
