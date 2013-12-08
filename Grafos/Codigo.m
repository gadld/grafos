//
//  Codigo.m
//  Grafos
//
//  Created by Gad Levy on 11/23/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "Codigo.h"

@interface Codigo ()

@end

@implementation Codigo
@synthesize id_alg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Check DB in doc directory.
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"algoritmos"];
}
- (void)viewDidLoad
{
    db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    
    if ([db open]) {
        
        
        FMResultSet *s2 = [db executeQuery:@"SELECT * FROM algoritmo where id_al=?",id_alg];
        
        while ([s2 next]) {
            codigo.text=[NSString stringWithFormat:@"Complejidad Temporal= %@\n\nComplejidad Espacial= %@\n\nTecnica de Diseño= %@\n\nCodgio: %@",[s2 objectForColumnName:@"comp_temp"],[s2 objectForColumnName:@"comp_esp"],[s2 objectForColumnName:@"tecnica"],[s2 objectForColumnName:@"codigo"]];
            
        }
    }
    [db close];
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
