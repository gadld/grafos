//
//  VistaDeArcos.m
//  Grafos
//
//  Created by Gad Levy on 11/5/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "VistaDeArcos.h"
#import "ViewController.h"

@implementation VistaDeArcos

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

        ViewController *v=(ViewController *)[self viewController];
        
        for (int i=0; i<v.nodos.count; i++) {
            NodoView *nodo=v.nodos[i];
            
            
                for (int j=0; j<[nodo.to count]; j++) {
                    
                    
                    int identificadorSig=(int)[[[nodo.to objectAtIndex:j] objectAtIndex:0] integerValue];
                    int peso=(int)[[[nodo.to objectAtIndex:j] objectAtIndex:1] integerValue];
                    int accion=(int)[[[nodo.to objectAtIndex:j] objectAtIndex:2] integerValue];
                    
                    
                    for(int a=0;a<v.nodos.count;a++)
                    {
                        
                        NodoView *nodoTemp=[v.nodos objectAtIndex:a];
                        
                        CGPoint destino= CGPointMake(nodoTemp.center.x, nodoTemp.center.y);
                        
                        if (nodoTemp.identificador==identificadorSig) {
                            //UIBezierPath *path=[UIBezierPath bezierPath];
                            //[[UIColor blackColor] setStroke];
                            
                            CGContextRef context=UIGraphicsGetCurrentContext();
                            //CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
                            //CGContextAddRect(context, CGRectMake(0, 0, 320, 480));
                           // CGContextFillRect(context,  CGRectMake(0, 0, 320, 480));
                          //  CGContextFillRect(<#CGContextRef c#>, <#CGRect rect#>)
                            
                            if (accion>0) {
                                [[UIColor greenColor] setStroke];
                                [[UIColor greenColor] setFill];
                                CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
                                CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
                            }
                            
                            //CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
                            //CGContextMoveToPoint(context, nodo.center.x, nodo.center.y);
                            //CGContextAddLineToPoint(context, destino.x, destino.y);
                            CGContextStrokePath(context);
                            //[path moveToPoint:nodo.center];
                            //[path addLineToPoint:destino];
                            
                            
                            double slopy, cosy, siny;
                            // Arrow size
                            double length = 20.0;
                            double width = 10.0;
                            
                            slopy = atan2((nodo.center.y - destino.y), (nodo.center.x - destino.x));
                            cosy = cos(slopy);
                            siny = sin(slopy);
                            
                            if (peso!=1) {
                                
                                NSString *s=[NSString stringWithFormat:@"%i",peso];
                                [s drawAtPoint:CGPointMake(((5*nodo.center.x+8*destino.x)/13), ((5*nodo.center.y+8*destino.y)/13)) withAttributes:nil];
                            }
                            
                            
                            //draw a line between the 2 endpoint
                            CGContextMoveToPoint(context, nodo.center.x, nodo.center.y );
                            
                           
                            static CGFloat const kDashedPhase           = (0.0f);
                            static CGFloat const kDashedLinesLength[]   = {1};
                            static size_t const kDashedCount            = (2.0f);
                            CGContextSetLineDash(context,0,kDashedLinesLength,0);
                  
                            if (accion==2) {
                                [[UIColor greenColor] setStroke];
                                [[UIColor greenColor] setFill];
                                CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
                                CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
                              
                            }
                            if (accion==3) {
                                [[UIColor redColor] setStroke];
                                [[UIColor redColor] setFill];
                                CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
                                CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
                                
       ;
                                static CGFloat const kDashedPhase           = (0.0f);
                                static CGFloat const kDashedLinesLength[]   = {4.0f, 2.0f};
                                static size_t const kDashedCount            = (2.0f);
                                
                                //CGContextSaveGState(context);
                                CGContextSetLineDash(context, kDashedPhase, kDashedLinesLength, kDashedCount);
                            }
                        
                        //CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
                            
                            
                            CGContextAddLineToPoint(context, destino.x + length * cosy, destino.y + length * siny);
                            CGContextStrokePath(context);
                           // CGContextRestoreGState(context);
                           
                            
                            
                            CGContextMoveToPoint(context, destino.x + length * cosy, destino.y + length * siny);
                            CGContextAddLineToPoint(context,
                                                    destino.x + length * cosy +  (length * cosy - ( width / 2.0 * siny )),
                                                    destino.y + length * siny+  (length * siny + ( width / 2.0 * cosy )) );
                            CGContextAddLineToPoint(context,
                                                    destino.x + length * cosy+  (length * cosy + width / 2.0 * siny),
                                                    destino.y + length * siny -  (width / 2.0 * cosy - length * siny) );
                            CGContextClosePath(context);
                            CGContextFillPath(context);
                            
                            //DIBUJAR
                            break;
                        }
                    }
                    
                    /*
                    NSString *s=[nodo.to objectAtIndex:j];
                    
                    
                    int angulo=j*aumento+270;
                    
                    
                    float xx= cos(angulo*M_PI/180);
                    float yy= sin(angulo*M_PI/180);
                    
                    float x1=centroX+radio*xx;
                    float y2=centroY+radio*yy;
                    
                    
                    
                    NSLog(@"x %f, y %f",x1,y1);
                    
                    v.grafo->getNode(i)->to[j].w;
                    v.grafo->getNode(i)->to[j].dest->value;
                    */
                }
                
                
/*
                
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(ctx, 5.0);
                CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
                CGContextBeginPath(ctx);
                CGContextMoveToPoint(ctx, self.location.x, self.location.y);
                CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
                CGContextStrokePath(ctx);
               
                UIGraphicsEndImageContext();
 
             */
            
        }
    
    
    // Drawing code
}
- (UIViewController *)viewController {
    if ([self.nextResponder isKindOfClass:UIViewController.class])
        return (UIViewController *)self.nextResponder;
    else
        return nil;
}


@end
