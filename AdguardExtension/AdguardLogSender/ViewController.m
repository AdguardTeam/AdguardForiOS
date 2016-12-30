//
//  ViewController.m
//  AdguardLogSender
//
//  Created by Roman Sokolov on 26.12.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "ViewController.h"
#import "AESSupport.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSend:(id)sender {
    
    [[AESSupport singleton] sendMailBugReportWithParentController:self];
}

@end
