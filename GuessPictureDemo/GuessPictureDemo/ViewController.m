//
//  ViewController.m
//  GuessPictureDemo
//
//  Created by jh on 15/8/6.
//  Copyright © 2015年 jh. All rights reserved.
//

#import "ViewController.h"
#import "JHQuestion.h"


@interface ViewController ()

- (IBAction)tip;
- (IBAction)help;
- (IBAction)bigImg;
- (IBAction)nextQuestion;

- (IBAction)iconClick;
//分数属性
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
//序号
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
//下一题按钮
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;


@property (weak, nonatomic) IBOutlet UIImageView *answerView;
@property (weak, nonatomic) IBOutlet UIImageView *optionView;



//阴影
@property (nonatomic,weak) UIButton *cover;

@property (nonatomic, strong)NSArray  *questions;  //所有题目
@property (nonatomic, assign)NSInteger index;       //当前第几题的序号

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;

}

//模型转字典
- (NSArray *)questions
{
    if (_questions == nil) {
        
        //加载plist
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
        
        //字典转模型
        NSMutableArray *questionArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            JHQuestion *question = [JHQuestion QuestionWithDict:dict];
            
            [questionArray addObject:question];
        }
        //赋值
        _questions = questionArray;
    }
    //返回
    return _questions;
}

//加载nib文件执行事件
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置出事index
    _index = -1;
    
    [self nextQuestion];

}

//添加分数
- (void)addScore:(int)daltaScore
{
    int score = [_scoreBtn titleForState:UIControlStateNormal].intValue;
    
    score += daltaScore;
    
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];


}

//提示
- (IBAction)tip {
    //1,点击监听事件
    for (UIButton *answerBtn in self.answerView.subviews) {
        [self answerclick:answerBtn];
    }
    //取出答案
    JHQuestion *question = self.questions[self.index];
    //答案的第一个文字
    NSString *firstAnswer = [question.answer substringToIndex:1];
    
    for (UIButton *optionBtn in self.self.optionView.subviews) {
        
        if ([optionBtn.currentTitle isEqualToString:firstAnswer]) {
            [self optionClick:optionBtn];
            
            break;
        }
       
    }
    [self addScore:-1000];
}

- (IBAction)help {
}

- (IBAction)bigImg {
    
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = self.view.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.cover = cover;
    
    // 2.更换阴影和头像的位置
    [self.view bringSubviewToFront:self.iconBtn];
    
    // 3.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 3.1.阴影慢慢显示出来
        cover.alpha = 0.7;
        
        // 3.2.头像慢慢变大,慢慢移动到屏幕的中间
        CGFloat iconW = self.view.frame.size.width;
        CGFloat iconH = iconW;
        CGFloat iconY = (self.view.frame.size.height - iconH) * 0.5;
        self.iconBtn.frame = CGRectMake(0, iconY, iconW, iconH);
    }];

}

//下一题引发的事件
- (IBAction)nextQuestion {
    
    //1,增加索引
    
    self.index ++;
    
    
    //2,取出模型
    
    JHQuestion *question = self.questions[self.index];
    
    
    //3,设置控件数据
    [self settingData:question];
    
    
    //4,添加正确答案
    [self addAnswerBtn:question];
    
    
    
    //5,添加待选答案
    [self addOption:question];
    
    
}

//设置数据
- (void)settingData:(JHQuestion *)question
{
    
    //设置控件数据
    //设置序号
    _noLabel.text = [NSString stringWithFormat:@"%d / %d",self.index + 1, self.questions.count];
    
    //设置标题
    _titleLabel.text = question.title;
    
    //设置图片
    [_iconBtn setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    
    //设置一下题状态
    
    self.nextQuestionBtn.enabled = self.index != (_questions.count - 1);

}

//点击下面的选择的字对按钮
- (void)addOption:(JHQuestion *)question
{
    // 6.1.删掉之前的所有按钮
    [self.optionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //设置带选项
    //删除之前所有按钮
//    for (UIView *subView in self.optionView.subviews) {
//        [subView removeFromSuperview];
//    }
    //2, 添加新的答案按钮
    int count = question.options.count;
    for (int i = 0; i < count ; i ++) {
        
        UIButton *optionBtn = [[UIButton alloc]init];
        //设置背景
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        //设置frame
        CGFloat optionW = 30;
        CGFloat optionH = 30;
        CGFloat margin = 18;
        CGFloat viewW = self.view.frame.size.width;
        
        int totalCol = 7;
        CGFloat leftMargin = (viewW - totalCol * optionW - margin * (totalCol - 1)) * 0.5;
        
        int col = i % totalCol;
        CGFloat optionX = leftMargin + col * (optionW + margin);
        
        int row = i / totalCol;
        CGFloat optionY = row * (optionH + margin);
        
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置文字
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [self.optionView addSubview:optionBtn];
        
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

/**
 *  监听待选按钮的点击
 */
- (void)optionClick:(UIButton *)optionBtn
{
    // 1.让被点击的待选按钮消失
    optionBtn.hidden = YES;
    
    // 2.显示文字到正确答案上
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字
            // 设置答案按钮的 文字 为 被点击待选按钮的文字
            NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            break; // 停止遍历
        }
    }
    
    // 3.检测答案是否填满
    BOOL full = YES;
    NSMutableString *tempAnswerTitle = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        // 判断按钮是否有文字
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) { // 没有文字(按钮没有填满)
            full = NO;
        }
        
        // 拼接按钮文字
        if(answerTitle) {
            [tempAnswerTitle appendString:answerTitle];
        }
    }
    
    // 4.答案满了
    if (full) {
        JHQuestion *question = self.questions[self.index];
        
        if ([tempAnswerTitle isEqualToString:question.answer]) { // 答对了(文字显示蓝色)
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            // 加分
            [self addScore:800];
            
            // 0.5秒后跳到下一题
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
        } else { // 答错了(文字显示红色)
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

//增加答案
- (void)addAnswerBtn:(JHQuestion *)question
{
    //添加正确答案
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //1，删除之前所有按钮
    
//    for (UIView *subView in self.answerView.subviews) {
//        [subView removeFromSuperview];
//    }
    //2, 添加新的答案按钮
    int length = question.answer.length;
    for (int i = 0; i < length;i ++) {
        UIButton *answerBtn = [[UIButton alloc]init];
        //设置背景
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置frame
        CGFloat margin = 10;
        CGFloat answerW = 35;
        CGFloat answerH = 35;
        CGFloat viewW = self.view.frame.size.width;
        // 最左边的间距 = 0.5 * (控制器view的宽度 - 按钮个数 * 按钮宽度 - (按钮个数 - 1) * 按钮之间的间距)
        CGFloat leftMargin = (viewW - length *answerW - margin * (length - 1)) * 0.5;
        // 按钮的x = 最左边的间距 + i * (按钮宽度 + 按钮之间的间距)
        CGFloat answerX = leftMargin + i * (answerW + margin);
        
        answerBtn.frame = CGRectMake(answerX, 0, answerW, answerH);
        [self.answerView addSubview:answerBtn];
        [answerBtn addTarget:self action:@selector(answerclick:) forControlEvents:UIControlEventTouchUpInside];
    }


}

//监听答案按钮
- (void)answerclick:(UIButton *)anwserBtn
{
    //答案按钮的文字
    NSString *answerTitle = [anwserBtn titleForState:UIControlStateNormal];
    
    //让答案按钮的文字对应待选按钮显示出来
    for (UIButton *optionBtn in self.optionView.subviews) {
        
        //待选按钮的文字
        NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
        
        if ([optionTitle isEqualToString:answerTitle]) {
            optionBtn.hidden = NO;
            break;
        }
    }
        //让被点击答案的文字消失
    [anwserBtn setTitle:nil forState:UIControlStateNormal];
    

}

//点击头像
- (IBAction)iconClick {
    if (self.cover == nil) {
        [self bigImg]; //没有遮盖，放大
    } else {
        [self smallImg]; //有遮盖，缩小
    
    }
}

- (void)smallImg
{
    
    [UIView animateWithDuration:0.3 animations:^{
        //存放需要执行动画的代码
        
        //恢复原来位置
        self.iconBtn.frame = CGRectMake(85, 80, 150, 150);
        self.cover.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        //动画执行完毕会自动调用block内部代码
        
        //删除阴影
        [self.cover removeFromSuperview];

        self.cover = nil;
    }];


}


@end
