//
//  LocationViewController.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *updatedToServerLabel;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)sendingUpdateToServer {
    if (self.view.window) {
        self.updatedToServerLabel.text = [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendingUpdateToServer) name:@"Sending update to server" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Sending update to server" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
