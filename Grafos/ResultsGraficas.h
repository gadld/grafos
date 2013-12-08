//
//  ResultsGraficas.h
//  Grafos
//
//  Created by Gad Levy on 11/19/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface ResultsGraficas : UIViewController<MFMailComposeViewControllerDelegate>
@property (nonatomic,retain)NSMutableDictionary *arreglo;
@end
