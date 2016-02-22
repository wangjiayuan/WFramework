//
//  ViewController.m
//  dahuozu
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 cheniue. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotoController.h"
#import "FunctionQueue.h"

@interface ViewController ()<TakePhotoDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [self simpleImageView:self.photoImageView setImagePath:@"http://img3.100bt.com/upload/ttq/20130127/1359278422138.gif" withPlaceholder:nil];
//    [self simpleImageView:self.photoImageView setImagePath:@"http://d.3987.com/cmnz_131009/005.jpg" withPlaceholder:nil];
    
    
    
    NSLog(@"%@",NSHomeDirectory());
    
//    [self makePlan];
    
}

-(void)scaleImage
{
    UIImage *image = [UIImage imageWithContentsOfFile:@"/Users/apple/Desktop/新背景图.jpg"];
    UIImage *newImage = [ImageFunction decodedImageWithImage:image toWidth:image.size.width];
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0f);
    
    CGFloat scale = 100.0f*1024.0f/data.length;
    
    data = UIImageJPEGRepresentation(newImage, scale);
    
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *newFilePath = @"/Users/apple/Desktop/最新背景图.jpg";
    
    if (![manage fileExistsAtPath:newFilePath])
    {
        [manage createFileAtPath:newFilePath contents:nil attributes:nil];
    }
    
    [data writeToFile:newFilePath atomically:YES];
}

- (IBAction)otherClick:(id)sender
{
    [self cancelPlan];
    
    if(self.presentingViewController==nil)
    {
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController  *vc = [board instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}
- (IBAction)clickWork:(id)sender
{
    [self choosePhotoImage];
//    [self function];
//    [self uploadPhoto];
//    [self requestData];
//    [self makePlan];
}
#pragma mark 测试的方法
-(void)cancelPlan
{
//    [[FunctionQueue shareQueue] removePlanWithMark:@"测试"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc
{
    MyMemoryLog(@"页面销毁");
}
-(void)makePlan
{
    WorkPlanObject *firstPlan = [[WorkPlanObject alloc] initWithTarget:self selector:@selector(requestData) object:nil];
    firstPlan.timeLeft = timeSinceNow(4.0f);
    firstPlan.mark = @"测试";
    [[FunctionQueue shareQueue] addPlan:firstPlan finshBlock:^(WorkPlanObject *plan) {
        MyDataLog(@"计划是：%@",plan);
    }];
}
-(void)requestData
{
    NSURLSessionDataTask *task = [self postRequestApi:@"CheniueDaHuo/queryuserinfo.html" parameters:@{@"user_id" : @"du2014092618492600625206"} finshBlock:^(id result, NSError *error)
     {
        NSLog(@"%@",result);
         NSLog(@"%@",self);
     }];
    task.taskDescription = @"个人信息";
    MyDataLog(@"请求的唯一标识：%@",task.taskDescription);
}
-(void)uploadPhoto
{
    [FileUploadManager uploadDahuozuApiRequest:nil imageData:[[PhotoObject alloc] initWithURL:@"http://d.3987.com/cmnz_131009/005.jpg"] progress:^(NSProgress *uploadProgress)
    {
        
        MyDataLog(@"进度：%.3f",uploadProgress.fractionCompleted)
    }
                                    finshBlock:^(id result, NSError *error)
    {
        NSLog(@"%@",result);
    }];
}
-(void)function
{
    TakePhotoController *vc = [[TakePhotoController alloc]init];
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)takePhoto:(PhotoObject *)photo doneState:(NSInteger)state
{
    if (state==0)
    {
        [self.photoImageView setImage:photo.smallImage];
    }
}
-(void)haveChoosePhotos:(NSArray<__kindof PhotoObject *> *)photos
{
    if ([photos count]>0)
    {
        [self.photoImageView setImage:[photos firstObject].smallImage];
    }
}
@end
