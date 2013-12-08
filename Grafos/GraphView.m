//
//  GraphView.m
//  Grafos
//
//  Created by Gad Levy on 11/19/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "GraphView.h"
#import "ResultsGraficas.h"
@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (ResultsGraficas *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[ResultsGraficas class]])
        {
            return (ResultsGraficas*)nextResponder;
        }
    }
    
    return nil;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    ResultsGraficas *g=(ResultsGraficas *)[self nextResponder];
    CGContextRef _context = UIGraphicsGetCurrentContext();
    
    NSArray *keys=[[
                   g arreglo]allKeys];
    
    
    int max=0;
    
    [@"ms" drawAtPoint:CGPointMake(5, 10) withAttributes:nil];
    for (int i=0; i<keys.count; i++) {
        if ([[[g arreglo] valueForKey:[keys objectAtIndex:i]]floatValue]>max) {
            max=[[[g arreglo] valueForKey:[keys objectAtIndex:i]]floatValue];
        }
    }
//Max -400
//val1 - x
    
    
    //porcentaje =
    
    for (int i=1; i<keys.count; i++) {
        float valor=[[[g arreglo] valueForKey:[keys objectAtIndex:i]]floatValue];

        
        [[NSString stringWithFormat:@"%d",max/i] drawAtPoint:CGPointMake(5, 430-(((max/i)*350)/max) ) withAttributes:nil];
        

    }
    
    for (int i=0; i<[[g arreglo] count]; i++) {
        float valor=[[[g arreglo] valueForKey:[keys objectAtIndex:i]]floatValue];
        NSString *s=[keys objectAtIndex:i];

        
        
 

        
            [s drawAtPoint:CGPointMake(i*40 +45, 430) withAttributes:nil];

    
        
        //[[NSString stringWithFormat:@"%.f",valor] drawAtPoint:CGPointMake(5, 410-((valor*350)/max) ) withAttributes:nil];
        
        
        CGContextAddRect(_context, CGRectMake(i*40 +45, 420-((valor*350)/max) , 30, ((valor*350)/max)));
        CGContextSetFillColorWithColor(_context, [[UIColor colorWithRed:0 green:0.735 blue:0.223 alpha:1] CGColor]);
        CGContextFillPath(_context);
    }

}


@end
