//
//  Menu.m
//  Grafos
//
//  Created by Gad Levy on 11/8/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "Menu.h"
#import "ViewController.h"
#import "PNChart.h"
#import "CustomIOS7AlertView.h"
#import "Codigo.h"
#import "ResultsGraficas.h"
@interface Menu ()

@end

@implementation Menu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)generarGrafo:(id)sender
{
    
    numNodos.minimumValue=3;
    numArcos.minimumValue=0;
    numNodos.maximumValue=15;
    numArcos.maximumValue=(int)numNodos.value*numNodos.value-numNodos.value;
    
    ViewController *v=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewController"];
    v.numarcos=numArcos.value;
    v.numnodos=numNodos.value;
    [self.navigationController pushViewController:v animated:YES];

}
-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}
- (void)copyDatabaseIfNeeded
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:[self getDBPath]];
    if(success)
    {
        return;// If exists, then do nothing.
    }
    //Get DB from bundle & copy it to the doc dirctory.
    NSString *databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"algoritmos"];
    [fileManager copyItemAtPath:databasePath toPath:[self getDBPath] error:nil];
}
//Check DB in doc directory.
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"algoritmos"];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dict=[NSMutableDictionary dictionary];
    
    db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    
    if ([db open]) {
        
        
    if (actionSheet.tag==1) {
        if (actionSheet.cancelButtonIndex==buttonIndex) {
            return;
        }
        //Graficas
        
        FMResultSet *s2 =  [db executeQuery:@"SELECT * FROM iteration WHERE algoritmo_i=?",[NSNumber numberWithInt: buttonIndex] ];
        
        
        
        while ([s2 next]) {
            
            FMResultSet *s3 =  [db executeQuery:@"SELECT nombre FROM grafo WHERE id_gr=?",[s2 objectForColumnName:@"grafo_i"]];
            
            while ([s3 next]) {
                [dict setObject:[s2 objectForColumnName:@"time"] forKey:[s3 objectForColumnName:@"nombre"]];
               
            }
        }
        
        ResultsGraficas *gr=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ResultsGraficas"];
        
        

        gr.arreglo=dict;
        
        [self.navigationController pushViewController:gr animated:YES];

        NSLog(@"dict %@",dict);
    }
    if (actionSheet.tag==2) {
        
        //Codigo
        if (actionSheet.cancelButtonIndex==buttonIndex) {
            return;
        }
        Codigo *c=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Codigo"];
        c.id_alg=[NSNumber numberWithInt:buttonIndex];
        
        [self.navigationController pushViewController:c animated:YES];
        /*
        FMResultSet *s2 =  [db executeQuery:@"SELECT * FROM algoritmo WHERE id_al=?",buttonIndex ];
        
        
        while ([s2 next]) {
            
            NSDictionary *resultRow = [s2 resultDictionary];
        }
         */
    }
    
        
    }
}
-(void)graficas
{
   
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Algoritmos" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Prim",@"Dijsktra",@"DFS",@"BFS",@"Kruskal",@"BellmanFord",@"FloydWarshall", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}
-(void)codigos
{


    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Algoritmos" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Prim",@"Dijsktra",@"DFS",@"BFS",@"Kruskal",@"BellmanFord",@"FloydWarshall", nil];
    sheet.tag=2;
    [sheet showInView:self.view];

}

-(void)viewWillAppear:(BOOL)animated
{
    grafos=[NSMutableArray array];
    [self copyDatabaseIfNeeded];
    db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    
    if ([db open]) {
        
        NSString *archivo=[[NSBundle mainBundle]pathForResource:@"codigo" ofType:@"txt"];
        NSString *codigo=[NSString stringWithContentsOfFile:archivo encoding:NSStringEncodingConversionExternalRepresentation error:nil];
        
        //[db executeUpdate:@"DELETE from algoritmo"];
       /*
        BOOL i= [db executeUpdate:@"INSERT INTO algoritmo (id_al,codigo,comp_temp,comp_esp,tecnica) values(?,?,?,?,?)",[NSNumber numberWithInt:6],codigo,@" (#nodos)^3",@" [int(pesos)]*(#nodos)^2, es la matriz de adyacencia modificada.",@"Programación dinámica"];
        NSLog(@"se pudo %i",i);
        FMResultSet *s4 =  [db executeQuery:@"SELECT * FROM algoritmo"];
        while ([s4 next]) {
            NSLog(@"%@",[s4 resultDictionary]);
        }
        
        
        */
        FMResultSet *s2 = [db executeQuery:@"SELECT * FROM grafo"];
        
        NSDictionary *resultRow;
        while ([s2 next]) {
            
            
            resultRow = [s2 resultDictionary];
            [grafos addObject:resultRow];
           // NSLog(@"aaa %@",resultRow);
        }
    }
    [db close];
    
    [tableView reloadData];

}
- (void)viewDidLoad
{
    
    
    self.title=@"Grafos";

    UIBarButtonItem *graficas=[[UIBarButtonItem alloc]initWithTitle:@"Graficas" style:UIBarButtonItemStyleBordered target:self action:@selector(graficas)];
    
    UIBarButtonItem *codigos=[[UIBarButtonItem alloc]initWithTitle:@"Codigos" style:UIBarButtonItemStyleBordered target:self action:@selector(codigos)];
    self.navigationItem.leftBarButtonItem=graficas;
    self.navigationItem.rightBarButtonItem=codigos;
    
        
    /*
    //For BarChart
    PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 200.0, 300, 200.0)];
    barChart.type = PNBarType;
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@"1",@"10",@"2",@"6",@"3"]];
    [barChart strokeChart];
    
    //By strokeColor you can change the chart color
    [barChart setStrokeColor:[UIColor greenColor]];
    
    [self.view addSubview:barChart];
    
    [self createPDFfromUIView:self.view saveToDocumentsWithFileName:@"grafica.pdf"];
    */
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  grafos.count+1;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    db = [FMDatabase databaseWithPath:[self getDBPath]];
    
    
    if ([db open]) {
        NSLog(@"id = %@",[[grafos objectAtIndex:indexPath.row] valueForKey:@"id_gr"]);
    [db executeUpdate:@"DELETE FROM grafo WHERE id_gr=?",[[grafos objectAtIndex:indexPath.row] valueForKey:@"id_gr"]];
   

    
    FMResultSet *s3 = [db executeQuery:@"SELECT * FROM grafo"];
    
    
    if ([s3 next]) {
        NSDictionary *d=[s3 resultDictionary];
        NSLog(@"d %@",d);
        int totalCount = [s3 intForColumnIndex:0];
        NSLog(@"id %i",totalCount);
        //[db executeUpdate:@"INSERT INTO grafo VALUES (?,?)", [NSNumber numberWithInt:totalCount+1 ],[NSNumber numberWithBool:NO]];
        
    }
    }
    [grafos removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    return UITableViewCellEditingStyleDelete;
    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1==grafos.count) {
        //return NO;
    }
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    
    
    
    if(indexPath.row==grafos.count)cell.textLabel.text=@"Nuevo";
    
    else cell.textLabel.text=[NSString stringWithFormat:@"%@",[[grafos objectAtIndex:indexPath.row] valueForKey:@"nombre"]];
    return cell;
}
-(void)numNodosValueChanged:(UISlider *)s
{
    [nombre resignFirstResponder];
    numNodos.minimumValue=3;
    numArcos.minimumValue=0;
    numNodos.maximumValue=15;
    numArcos.maximumValue=(int)numNodos.value*numNodos.value-numNodos.value;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==grafos.count)
    {
        CustomIOS7AlertView *alert=[[CustomIOS7AlertView alloc]init];
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0,0 , 220, 180)];
        
        nombre=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
        nombre.borderStyle=UITextBorderStyleLine;
        nombre.placeholder=@"Nombre del Grafo";
        
        UILabel *numNodosLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 30)];
        numNodosLabel.text=@"Numero de Nodos:";
        numNodos=[[NYSliderPopover alloc]initWithFrame:CGRectMake(10, 70, 180, 20)];
        [numNodos addTarget:self action:@selector(numNodosValueChanged:) forControlEvents:UIControlEventValueChanged];
        UILabel *numArcosLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
        numArcosLabel.text=@"Numero de Arcos:";
        numArcos=[[NYSliderPopover alloc]initWithFrame:CGRectMake(10, 130, 180, 20)];
        
        
        numNodos.minimumValue=3;
        numArcos.minimumValue=0;
        numNodos.maximumValue=15;
        numArcos.maximumValue=(int)numNodos.value*numNodos.value-numNodos.value;

        [v addSubview:nombre];
        [v addSubview:numNodosLabel];
        [v addSubview:numArcos];
        [v addSubview:numArcosLabel];
        [v addSubview:numNodos];
        
        [alert setContainerView:v];
        
        

        [alert setButtonTitles:[NSArray arrayWithObjects:@"Crear",@"Cancelar",nil]];
        [alert show];
        
        [nombre becomeFirstResponder];
        [alert setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
            
            if (buttonIndex==0) {
                ViewController *v=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewController"];
                v.numarcos=numArcos.value;
                v.numnodos=numNodos.value;
                v.nombreGrafo=nombre.text;
                [self.navigationController pushViewController:v animated:YES];
            }
            [alertView close];
        }];
        //ViewController *v=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewController"];
         //[self.navigationController pushViewController:v animated:YES];
    }
    else{
        ViewController *v=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ViewController"];
        NSNumber *n=[[grafos objectAtIndex:indexPath.row] valueForKey:@"id_gr"];
        v.idGrafo=n;

        [self.navigationController pushViewController:v animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
