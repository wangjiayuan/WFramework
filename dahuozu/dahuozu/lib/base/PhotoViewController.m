//
//  PhotoUpLoadViewController.m
//  dahuozu
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark 从相册里面选择多张图片
-(void)choosePhoto:(NSInteger)min max:(NSInteger)max
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    imagePickerController.minimumNumberOfSelection = min;
    imagePickerController.maximumNumberOfSelection = max;
    
    if (self.navigationController!=nil)
    {
        [self.navigationController pushViewController:imagePickerController animated:YES];
    }
    else
    {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
#pragma mark 从相册里面选择一张照片
-(void)choosePhotoImage
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = NO;
    
    if (self.navigationController!=nil)
    {
        [self.navigationController pushViewController:imagePickerController animated:YES];
    }
    else
    {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
#pragma mark 拍摄一张照片
-(void)takePhoto
{
    TakePhotoController *takeVC = [[TakePhotoController alloc]init];
    [takeVC setDelegate:self];
    if (self.navigationController!=nil)
    {
        [self.navigationController pushViewController:takeVC animated:YES];
    }
    else
    {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:takeVC];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
#pragma mark 选择照片代理
-(void)takePhoto:(PhotoObject *)photo doneState:(NSInteger)state
{
    if (state==0)
    {
        [self haveChoosePhotos:@[photo]];
    }
}
#pragma mark 选择照片完成
-(void)haveChoosePhotos:(nullable NSArray<__kindof PhotoObject *> *)photos
{
    
}
#pragma mark 移除照片选择视图
-(void)dismissImagePickerController
{
    if (self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}
#pragma mark 照片选择代理实现的方法
-(void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    PhotoObject *photo = [[PhotoObject alloc]initWithAsset:asset];
    [self haveChoosePhotos:@[photo]];
    [self dismissImagePickerController];
}
-(void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSMutableArray *photos = [NSMutableArray array];
    for (ALAsset *asset in assets)
    {
        PhotoObject *photo = [[PhotoObject alloc]initWithAsset:asset];
        [photos addObject:photo];
    }
    [self haveChoosePhotos:photos];
    [self dismissImagePickerController];
}
-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissImagePickerController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#pragma clang diagnostic pop
