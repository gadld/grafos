//
//  NodoView.m
//  Grafos
//
//  Created by Gad Levy on 11/4/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "NodoView.h"

@implementation NodoView
@synthesize centro,label,to,identificador;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
