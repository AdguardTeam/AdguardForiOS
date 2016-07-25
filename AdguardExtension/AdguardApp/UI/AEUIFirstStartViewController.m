//
//  AEUIFirstStartViewController.m
//  Adguard
//
//  Created by Roman Sokolov on 22/07/16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "AEUIFirstStartViewController.h"

@interface AEUIFirstStartViewController ()

@end

@implementation AEUIFirstStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef PRO

    self.backgroundImage.image = [UIImage imageNamed:@"pro-launch-background"];
#else
    
    self.backgroundImage.image = [UIImage imageNamed:@"launch-background"];
#endif
    
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
