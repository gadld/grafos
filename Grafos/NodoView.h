//
//  NodoView.h
//  Grafos
//
//  Created by Gad Levy on 11/4/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NodoView : UIView
@property NSString *label;
@property CGPoint centro;
@property NSMutableArray *to;
@property int identificador;
@end
