//
//  ViewController.m
//  MXNetworking-OC-Demo
//
//  Created by Meniny on 16/7/8.
//  Copyright © 2016年 Meniny. All rights reserved.
//

#import "ViewController.h"
#import "MXNetworkingMethods.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray <NSString *>* dataSource;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setSemaphore:dispatch_semaphore_create(1)];
    [self setQueue:dispatch_queue_create([NSStringFromClass([self class]) cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL)];
    
#pragma mark REQUEST HEADER
    
    NSMutableDictionary *headers = [[NSMutableURLRequest standardHeaders] mutableCopy];
    [headers setValue:@"ACGArt/6.0.1 CFNetwork/758.1.6 Darwin/15.0.0" forKey:@"User-Agent"];
    [headers setValue:@"*/*" forKey:@"Accept"];
    [NSMutableURLRequest setStandardHeaders:headers];
    
#pragma mark BASR URL
    
    [MXNetworking setBaseURLString:@"http://acg.sugling.in"];
    
    [self requestList];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestList)]];
}

- (NSMutableArray<NSString *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)requestList {
    __weak typeof(self) weakSelf = self;
    dispatch_async([self queue], ^{
        if (dispatch_semaphore_wait([weakSelf semaphore], DISPATCH_TIME_FOREVER) == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Loading
            });
            
            NSString *sexy = @"yes";
            
            NSString *version = @"c.6.0.1";
            
            NSString *device = @"iphone5";
            
            NSString *url = [MXNetworking urlByAppendingParameters:@{
                                                               @"device": device,
                                                               @"sexyfilter": sexy,
                                                               @"version": version
                                                               } toURL:@"/json_daily.php"];
            [MXNetworking getRequestByAppending:url forType:RequestTypeURL data:nil callback:^(ResponseStatus status, id responseObject) {
                // Main Thread:
                BOOL success = NO;
                NSMutableArray <NSString *>*urls = [NSMutableArray array];
                if (status == ResponseStatus200) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSArray *data = [responseObject objectForKey:@"data"];
                        if (data != nil && [data isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *day in data) {
                                if (day != nil && [day isKindOfClass:[NSDictionary class]]) {
                                    NSArray *imgs = [day objectForKey:@"imgs"];
                                    if (imgs != nil && [imgs isKindOfClass:[NSArray class]]) {
                                        for (NSString *name in imgs) {
                                            if (name != nil && [name isKindOfClass:[NSString class]]) {
                                                [urls addObject:[name copy]];
                                                success = YES;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (success) {
                    [[weakSelf dataSource] removeAllObjects];
                    [[weakSelf dataSource] addObjectsFromArray:urls];
                    // Reload
                } else {
                    NSLog(@"Error");
                    // Error
                }
                dispatch_semaphore_signal([weakSelf semaphore]);
            }];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
