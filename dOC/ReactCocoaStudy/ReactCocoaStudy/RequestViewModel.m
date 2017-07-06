//
//  RequestViewModel.m
//  ReactCocoaStudy
//
//  Created by runo on 17/7/4.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "RequestViewModel.h"
#import "Book.h"

@interface RequestViewModel ()

@end

@implementation RequestViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    _requesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"q"] = @"基础";
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString *urlString = [NSString stringWithFormat:@"%@?%@",@"https://api.douban.com/v2/book/search",@"q=基础"];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *postUrl = [NSURL URLWithString:urlString];
            
            NSURLSessionDataTask *task = [session dataTaskWithURL:postUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [subscriber sendNext:dic];
                [subscriber sendCompleted];
            }];
            
            [task resume];
            return nil;
            
        }];
        
        return  [singal map:^id _Nullable(id  _Nullable value) {
            
            NSMutableArray *dictArr = value[@"books"];
            
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                return [Book bookWithDict:value];
            }] array];
            return modelArr;
        }];
    }];
}

#pragma tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = ((Book *)self.models[indexPath.row]).name;
    return cell;
}

@end
