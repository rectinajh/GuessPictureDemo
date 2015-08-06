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

//序号
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
//下一题按钮
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;


@property (weak, nonatomic) IBOutlet UIImageView *answerView;



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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = -1;
    
    [self nextQuestion];

}



- (IBAction)tip {
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

//下一题
- (IBAction)nextQuestion {
    
    _index ++;
    
    //取出模型
    JHQuestion *qustion = self.questions[self.index];
    //设置控件数据®
    //设置序号
    _noLabel.text = [NSString stringWithFormat:@"%d / %d",self.index + 1, self.questions.count];
    
    //设置标题
    _titleLabel.text = qustion.title;
    
    //设置图片
    [_iconBtn setImage:[UIImage imageNamed:qustion.icon] forState:UIControlStateNormal];
    
    //设置一下题状态
    
    self.nextQuestionBtn.enabled = self.index != (_questions.count - 1);
    
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
