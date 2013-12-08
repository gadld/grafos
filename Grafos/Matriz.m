//
//  Matriz.m
//  Grafos
//
//  Created by Gad Levy on 11/23/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "Matriz.h"

@interface Matriz ()

@end

@implementation Matriz
@synthesize s;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [web loadHTMLString:s baseURL:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
