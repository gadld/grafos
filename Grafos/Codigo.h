//
//  Codigo.h
//  Grafos
//
//  Created by Gad Levy on 11/23/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface Codigo : UIViewController
{
    __weak IBOutlet UILabel *nombre;
    __weak IBOutlet UILabel *compTemp;
    __weak IBOutlet UILabel *compEsp;
    __weak IBOutlet UILabel *tecnica;
    __weak IBOutlet UITextView *codigo;
    
    FMDatabase *db;
}
@property NSNumber *id_alg;
@end
