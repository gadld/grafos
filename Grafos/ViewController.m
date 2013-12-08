//
//  ViewController.m
//  Grafos
//
//  Created by Gad Levy on 10/7/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "ViewController.h"
#import "ResultsGraficas.h"
#import "CRTableViewCell.h"
#import "Matriz.h"
#define kDefaultPageWidth 300
#define kDefaultPageHeight 1000
#define kMargin 20
#define kColumnMargin 50

#define HEIGHT_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5)
@interface ViewController ()
{
    
}
@end



@implementation ViewController
@synthesize nodos,grafo,numarcos,numnodos,nodo1,nodo2,idGrafo,nombreGrafo;
-(id) init {
    
    
    return self;
}

-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    for(int i=0;i<nodos.count;i++){
        NodoView *n=[nodos objectAtIndex:i];
        if (n.identificador==3) {
            n.layer.borderColor=[UIColor blueColor].CGColor;
            nodo1=n;
            
        }
        
        

    }

}


//Check DB in doc directory.
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"algoritmos"];
}
-(void)tappedNode:(UITapGestureRecognizer *)tap
{
    NodoView *v=(NodoView *)tap.view;
    
    
    if (selectedNode1>=0) {
        selectedNode2=v.identificador;
        
        grafo->newArc(grafo->getNode(selectedNode1), grafo->getNode(selectedNode2));
        
        
        for (NodoView *vv in nodos) {
            if (vv.identificador==selectedNode1) {
                NSMutableArray *a=[NSMutableArray array];
                
                [a addObject:[NSNumber numberWithInt:selectedNode2]];
                //NSLog(@"i %i",grafo->findNode(grafo->getNode(i)->to[j].w));
                [a addObject:[NSNumber numberWithInt:1]];
                [a addObject:[NSNumber numberWithInt:0]];
                //int aaa= grafo->getNode(i)->to[j].w;
                
                
                [vv.to addObject:a];
                break;
            }
        }

        
        
    
        
        
        selectedNode1=-1;
        selectedNode2=-1;
        
        [self.view setNeedsDisplay];
    }
    else if (selectedNode1==v.identificador)
    {
        selectedNode1=-1;
        selectedNode2=-1;
    }
    else
    {
        selectedNode1=v.identificador;
    
    }
    
    
    
}
-(void)guardarGrafo
{
    grafo->sortAllArcs();
    resultados=[NSMutableArray array];
    
    if (idGrafo.intValue==0) {
        db = [FMDatabase databaseWithPath:[self getDBPath]];
        NSLog(@"db %@",db);
        int totalCount;
        if ([db open]) {
            
            
            
            
            FMResultSet *s3 = [db executeQuery:@"SELECT count(*) FROM grafo"];
            
            if ([s3 next]) {
                
                //totalCount = [s3 intForColumnIndex:0];
                
                NSLog(@"totalCoiunt %i",totalCount);
                [db executeUpdate:@"INSERT INTO grafo(dirigido,nombre) VALUES (?,?)",[NSNumber numberWithBool:grafo->directed()],[NSString stringWithFormat:@"%s",grafo->name.c_str()]];//, [NSNumber numberWithBool:totalCount],[NSNumber numberWithBool:1]];
                
                FMResultSet *s4 = [db executeQuery:@"SELECT MAX(id_gr) FROM grafo"];
                
                if ([s4 next]) {
                    totalCount = [s4 intForColumnIndex:0];
                    NSLog(@"totalCount %i",totalCount);
                    for(int i=0;i<grafo->n();i++){
                        //totalCount = [s3 intForColumnIndex:0];
                        [db executeUpdate:@"INSERT INTO nodo VALUES (?,?,?)",[NSNumber numberWithInt:i],[NSNumber numberWithInt:totalCount],[NSNumber numberWithInt:grafo->getNode(i)->value]];
                    }
                }
                
            }
            
            int ** tablaArcos;
            tablaArcos= grafo->getArcsTable();
            int i=0;
            while (tablaArcos[i][0] != -1) {
                NSLog(@"%i",tablaArcos[i][0]);
                [db executeUpdate:@"INSERT INTO arco VALUES (?,?,?,?)",[NSNumber numberWithInt:totalCount],[NSNumber numberWithInt:tablaArcos[i][0]],[NSNumber numberWithInt:tablaArcos[i][1]],[NSNumber numberWithInt:tablaArcos[i][2]]];
                i++;
            }
        }
        
        
        [db close];
        
        idGrafo=[NSNumber numberWithInt:totalCount+1];
        
    }
    else
    {
        db = [FMDatabase databaseWithPath:[self getDBPath]];
        NSLog(@"db %@",db);
        int totalCount;
        if ([db open]) {
            
            
            
            
            
            [db executeUpdate:@"UPDATE grafo(dirigido,nombre) VALUES (?,?) WHERE id_gr=?",[NSNumber numberWithBool:grafo->directed()],[NSString stringWithFormat:@"%s",grafo->name.c_str()],idGrafo];//, [NSNumber numberWithBool:totalCount],[NSNumber numberWithBool:1]];
            
            
            [db executeUpdate:@"DELETE from nodo where grafo_n=?",idGrafo];
            [db executeUpdate:@"DELETE from arco where grafo_a=?",idGrafo];
            
            for(int i=0;i<grafo->n();i++){
                [db executeUpdate:@"INSERT INTO nodo VALUES (?,?,?)",[NSNumber numberWithInt:i],idGrafo,[NSNumber numberWithInt:grafo->getNode(i)->value]];
            }
            
        }
        
        int ** tablaArcos;
        tablaArcos= grafo->getArcsTable();
        int i=0;
        while (tablaArcos[i][0] != -1) {
            NSLog(@"%i",tablaArcos[i][0]);
            [db executeUpdate:@"INSERT INTO arco VALUES (?,?,?,?)",idGrafo,[NSNumber numberWithInt:tablaArcos[i][0]],[NSNumber numberWithInt:tablaArcos[i][1]],[NSNumber numberWithInt:tablaArcos[i][2]]];
            i++;
        }
    }
    
    
    [db close];
    

}
-(void)addNode
{
    char aa[]={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T'};
    grafo->newNode(aa[grafo->n()]);
    [self dibujarGrafo];
}


-(void)calcular:(NSString *)s
{

    
    if ([s isEqualToString:@"Prim"]) {
        
        arreglo=grafo->primAn(grafo->getNode(0));
    }
    if ([s isEqualToString:@"Dijsktra"]) {
        arreglo=grafo->dijkstraAn(grafo->getNode(0));
    }
    if ([s isEqualToString:@"DFS"]) {
        arreglo=grafo->dfs(0);
    }
    if ([s isEqualToString:@"BFS"]) {
        arreglo=grafo->bfs(grafo->getNode(0));
    }
    if ([s isEqualToString:@"Kruskal"]) {
        NSLog(@"kru");
        arreglo=grafo->kruskal();
    }
    if (!manual) {
        [self animar:@""];
    }

    
}
int cDij;
-(void)animar:(NSString *)s
{
    
    if (pausar) {
        return;
    }
    
    
    
    int accion=arreglo[cDij][0];
    int nodo=arreglo[cDij][1];
    int arco=arreglo[cDij][2];
    
    if (accion==-1) {
        return;
    }
    if (arco==-1) {
        //no hay arco involucradp
        if (accion==1) {
            NodoView *nd=[nodos objectAtIndex:nodo];
            nd.layer.borderColor=[UIColor greenColor].CGColor;
        }
        
    }
    else
    {
        NodoView *nd=[nodos objectAtIndex:nodo];
        [[nd.to objectAtIndex:arco] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:accion ]];
    
        [self.view clearsContextBeforeDrawing];
        [self.view setNeedsDisplay];
    }
    
    
    cDij++;
    
    
    if (!pausar) {
        if (tiempoReal) {
            [self performSelector:@selector(animar:) withObject:s afterDelay:0];
        }
        else [self performSelector:@selector(animar:) withObject:s afterDelay:1];
    }
    
}
-(void)animarManual:(NSString *)s
{
    
    if (pausar) {
        return;
    }
    
    
    
    int accion=arreglo[cDij][0];
    int nodo=arreglo[cDij][1];
    int arco=arreglo[cDij][2];
    
    if (accion==-1) {
        manual=FALSE;
    }
    if (arco==-1) {
        //no hay arco involucradp
        if (accion==1) {
            NodoView *nd=[nodos objectAtIndex:nodo];
            nd.layer.borderColor=[UIColor greenColor].CGColor;
        }
        
    }
    else
    {
        NodoView *nd=[nodos objectAtIndex:nodo];
        [[nd.to objectAtIndex:arco] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:accion ]];
        
        [self.view clearsContextBeforeDrawing];
        [self.view setNeedsDisplay];
    }
    
    
    
    

    
}
-(void)correr:(NSString *)s
{
    grafo->sortAllArcs();
    long tiempo;
    int idd;
    if ([s isEqualToString:@"Prim"]) {
        
        clock_t c1=clock();
        grafo->prim(grafo->getNode(0));
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=1;
        
    }
    if ([s isEqualToString:@"Dijsktra"]) {
        clock_t c1=clock();
        grafo->dijkstra(grafo->getNode(0));
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=2;
    }
    if ([s isEqualToString:@"DFS"]) {
        clock_t c1=clock();
        grafo->dfs(grafo->getNode(0));
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=3;
    }
    if ([s isEqualToString:@"BFS"]) {
        clock_t c1=clock();
        grafo->bfs(grafo->getNode(0));
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=4;
    }
    if ([s isEqualToString:@"Kruskal"]) {
        clock_t c1=clock();
        grafo->kruskal();
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=5;
    }
    if ([s isEqualToString:@"BellmanFord"]) {
        clock_t c1=clock();
        grafo->kruskal();
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=6;
    }
    if ([s isEqualToString:@"FloydWarshall"]) {
        clock_t c1=clock();
        grafo->kruskal();
        clock_t c2=clock();
        tiempo=c2-c1;
        idd=7;
    }
    
    

    db = [FMDatabase databaseWithPath:[self getDBPath]];
    NSLog(@"db %@",db);
    int totalCount;
    
    [self guardarGrafo];
    
    if ([db open]) {
        
        [db executeUpdate:@"INSERT INTO iteration (time, grafo_i, algoritmo_i) VALUES (?,?,?)",[NSNumber numberWithLong:tiempo],idGrafo,[NSNumber numberWithInt:idd]];
        
    }
}
-(void)dibujarGrafo
{
    grafo->sortAllArcs();
    if (grafo->n()==0) {
        return;
    }
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[NodoView class]]) {
            [v removeFromSuperview];
        }
    }
    nodos=[[NSMutableArray alloc]init];
    
    
    
    int cantidad=grafo->n();
    int centroX=150;
    int centroY=240;
    int radio=140;
    float aumento=360/cantidad;
    float angulo=90;
    for(int i=0;i<cantidad;i++){
        angulo=i*aumento+270;
        
        float cosin=cos(angulo);
        
        float xx= cos(angulo*M_PI/180);
        float yy= sin(angulo*M_PI/180);
        
        float x=centroX+radio*xx;
        float y=centroY+radio*yy;
        //NSLog(@"x coseno %f  radio %f total %f",result,cos(result)*radio,centroX+radio*(cos(result)) );
        NodoView *v=[[NodoView alloc]initWithFrame:CGRectMake(x, y, 35, 35)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedNode:)];
        [v addGestureRecognizer:tap];
        NSMutableArray *arcos=[NSMutableArray array];
        for (int j=0; j<grafo->getNode(i)->to.size(); j++) {
            NSMutableArray *a=[NSMutableArray array];
            
            [a addObject:[NSNumber numberWithInt:grafo->findNode(grafo->getNode(i)->to[j].dest)]];
            //NSLog(@"i %i",grafo->findNode(grafo->getNode(i)->to[j].w));
            [a addObject:[NSNumber numberWithInt:grafo->getNode(i)->to[j].w]];

            [a addObject:[NSNumber numberWithInt:0]];
            //int aaa= grafo->getNode(i)->to[j].w;
            
            [arcos addObject:a];
            //[arcos addObject:grafo->getNode(i)->value];
            
        }
        v.label=[NSString stringWithFormat:@"%c", grafo->getNode(i)->value ];
        v.to=arcos;
        v.backgroundColor=[UIColor whiteColor];
        v.identificador=grafo->findNode(grafo->getNode(i));
        v.layer.borderWidth=2;
        v.layer.borderColor=[UIColor redColor].CGColor;
        v.layer.cornerRadius=17;
        UILabel *l=[[UILabel alloc]initWithFrame:CGRectMake(4, 0, 20, 20)];
        
        
        NSString *nombre=[NSString stringWithFormat:@"%c",grafo->getNode(i)->value];
        l.text=nombre;
        [v addSubview:l];
        
        [nodos addObject:v];
        
        [self.view addSubview:v];
        
    }

     [self.view setNeedsDisplay];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    CRTableViewCell *cell=[[CRTableViewCell alloc]init];
        
    if (cell == nil)
    {
        cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //[ cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
    }
    cell.textLabel.text=[algoritmos objectAtIndex:indexPath.row];
    
    cell.isSelected = [selectedAlgorithms containsObject:cell.textLabel.text] ? YES : NO;
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==3) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([selectedAlgorithms containsObject:cell.textLabel.text]){// Is selected?
            [selectedAlgorithms removeObject:cell.textLabel.text];
            
        }
        
        else{
            [selectedAlgorithms addObject:cell.textLabel.text];
            
        }
        
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}


-(void)showAlg
{
    UITableView *tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 200)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.tag=3;

    UIToolbar *t=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *seleccionar=[[UIBarButtonItem alloc]initWithTitle:@"Correr" style:UIBarButtonItemStyleBordered target:self action:@selector(correr:)];
    [t setItems:[NSArray arrayWithObject:seleccionar]];
    
    algoritmosView=[[UIView alloc]initWithFrame:CGRectMake(0, 367+88*IS_IPHONE_5, 320, 200)];
    [algoritmosView addSubview:t];
    [algoritmosView addSubview:tb];
    [self.view addSubview:algoritmosView];
    
    [UIView animateWithDuration:1 animations:^{algoritmosView.frame=CGRectMake(0, 225+88*IS_IPHONE_5, 320, 200);}];
}
/*
-(void)correr:(UIView *)v{
    for(int i=0;i<selectedAlgorithms.count;i++)
    {
        if ([[selectedAlgorithms objectAtIndex:i]isEqualToString:@"Dijsktra"]) {
            NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(dijsktra) object:nil];
            [thread start];
        }
        if ([[selectedAlgorithms objectAtIndex:i]isEqualToString:@"BFS"]) {
            NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(bfs) object:nil];
            [thread start];
        }
    }
    [algoritmosView removeFromSuperview];
    
}
*/
-(void)results
{
    //[self animar];
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Resultados" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:Nil otherButtonTitles:@"Grafica",@"Tabla",@"Animacion",@"Correr Algoritmo", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==1){
        if (buttonIndex==0) {
            
            ResultsGraficas *gr=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ResultsGraficas"];
            
            //:@"Prim",@"Dijsktra",@"DFS",@"BFS",@"Kruskal",@"BellmanFord",@"FloydWarshall", nil];
            
            NSThread *thread1=[[NSThread alloc]initWithTarget:self selector:@selector(prim) object:nil];
            [thread1 start];
            NSThread *thread2=[[NSThread alloc]initWithTarget:self selector:@selector(dijsktra) object:nil];
            [thread2 start];
            NSThread *thread3=[[NSThread alloc]initWithTarget:self selector:@selector(dfs) object:nil];
            [thread3 start];
            NSThread *thread4=[[NSThread alloc]initWithTarget:self selector:@selector(bfs) object:nil];
            [thread4 start];
            NSThread *thread5=[[NSThread alloc]initWithTarget:self selector:@selector(kruskal) object:nil];
            [thread5 start];
            NSThread *thread6=[[NSThread alloc]initWithTarget:self selector:@selector(bellman) object:nil];
            [thread6 start];
            NSThread *thread7=[[NSThread alloc]initWithTarget:self selector:@selector(floyd) object:nil];
            [thread7 start];
   
            sleep(3);
            gr.arreglo=tiempos;
            [self.navigationController pushViewController:gr animated:YES];

            //grafica
        }
        if (buttonIndex==1) {
            //tabla
            UIActionSheet *sh=[[UIActionSheet alloc]initWithTitle:@"Matriz" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Matriz",@"FloydWarshall", nil];
            
            sh.tag=4;
            [sh showInView:self.view];
            
        }
        if (buttonIndex==2) {
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Algoritmos" delegate:self cancelButtonTitle:nil destructiveButtonTitle:Nil otherButtonTitles:nil];
            for(NSString *s in algoritmos)
            {
                if ([s isEqualToString:@"BellmanFord"]) {
                    continue;
                }
                if ([s isEqualToString:@"FloydWarshall"]) {
                    continue;
                }
                
                [sheet addButtonWithTitle:s];
            }
            [sheet addButtonWithTitle:@"Cancelar"];
            sheet.cancelButtonIndex = [algoritmos count]-2;
            sheet.tag=2;
            [sheet showInView:self.view];
        }
        if (buttonIndex==3) {
            
            UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Algoritmos" delegate:self cancelButtonTitle:nil destructiveButtonTitle:Nil otherButtonTitles:nil];
            for(NSString *s in algoritmos)
            {
                [sheet addButtonWithTitle:s];
            }
            [sheet addButtonWithTitle:@"Cancelar"];
            sheet.cancelButtonIndex = [algoritmos count];
            
            sheet.tag=3;
            [sheet showInView:self.view];
        }
    }
    else if (actionSheet.tag==2)
    {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Seleccion" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:Nil otherButtonTitles:@"Manual",@"Automatico",@"Tiempo Real",nil];
        sheet.tag=5;
        [sheet showInView:self.view];
        
       
        //[self animar:[algoritmos objectAtIndex:buttonIndex-1]];
    }
    else if (actionSheet.tag==3)
    {
        gad=buttonIndex-1;
        [self correr:[algoritmos objectAtIndex:buttonIndex-1]];
    }
    else if (actionSheet.tag==4)
    {
        int** a;
        if (buttonIndex==0) {
            a=grafo->matrix();
        }
        else if(buttonIndex==1)
            a=grafo->floydWarshall();
        
        NSMutableString *s=[NSMutableString string];
        
        [s appendFormat:@"<table>"];
        for(int i=0;i<grafo->n();i++)
        {
            [s appendFormat:@"<tr><td>%c</td>",grafo->getNode(i)->value];
            printf("%c",grafo->getNode(i)->value);
            for(int j=0;j<grafo->n();j++)
            {
                if(a[i][j]==10000)
                    [s appendFormat:@"<td style='width:100px'>-</td>"];
                else
                    [s appendFormat:@"<td style='width:100px'>%i</td>",a[i][j]];
                
                printf("%i  ",a[i][j]);
            }
            [s appendFormat:@"</tr>"];
            printf("\n");
            
            
        }
        [s appendFormat:@"<table>"];
        
        Matriz *m =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Matriz"];
        m.s=s;
        [self.navigationController pushViewController:m animated:YES];
        
        

    }
    if (actionSheet.tag==5) {
        manual=FALSE;
        tiempoReal=FALSE;
        if (buttonIndex==0) {
            manual=TRUE;
        }
        if (buttonIndex==2) {
            tiempoReal=TRUE;
        }
         [self calcular:[algoritmos objectAtIndex:gad]];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (manual) {
        [self animarManual:@""];
        cDij++;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
}
-(void)viewWillDisappear:(BOOL)animated{
    pausar=TRUE;
    delete grafo;
    //[self removeFromParentViewController];
    
}
//-(void)viewWillAppear:(BOOL)animated{grafo->clearGraph();}
- (void)viewDidLoad
{
    cDij=0;
    tiempos=[[NSMutableDictionary alloc] init];
    selectedNode1=-1;
    selectedNode2=-1;
 
    
    
    algoritmos=[NSArray arrayWithObjects:@"Prim",@"Dijsktra",@"DFS",@"BFS",@"Kruskal",@"BellmanFord",@"FloydWarshall", nil];
    selectedAlgorithms=[[NSMutableArray alloc]init];
    toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 435+88*IS_IPHONE_5, 320, 40)];
    //UIBarButtonItem *algoritmo=[[UIBarButtonItem alloc]initWithTitle:@"Algoritmos" style:UIBarButtonItemStyleBordered target:self action:@selector(showAlg)];
    
    UIBarButtonItem *espacio=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *results=[[UIBarButtonItem alloc]initWithTitle:@"Resultados" style:UIBarButtonItemStyleBordered target:self action:@selector(results)];
    
    
    UIBarButtonItem *guardar=[[UIBarButtonItem alloc]initWithTitle:@"Guardar" style:UIBarButtonItemStyleBordered target:self action:@selector(guardarGrafo)];

    
    
    [toolbar setItems:[NSArray arrayWithObjects:guardar,espacio,results, nil]];
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithTitle:@"Nuevo" style:UIBarButtonItemStyleBordered target:self action:@selector(addNode)];
    self.navigationItem.rightBarButtonItem=add;
    
    NSDictionary *resultRow;
    NSDictionary *resultRow2;

    
    resultados=[NSMutableArray array];
    db = [FMDatabase databaseWithPath:[self getDBPath]];
    NSLog(@"db %@",db);
    
    if (idGrafo>0) {
        if ([db open]) {
            
            //[db executeUpdate:@"INSERT INTO algoritmo (id_al) VALUES (?)", [NSNumber numberWithInt:1]];
            
            FMResultSet *s3 = [db executeQuery:@"SELECT * FROM grafo"];
            
            if ([s3 next]) {
                NSDictionary *d=[s3 resultDictionary];
                NSLog(@"d %@",d);
                int totalCount = [s3 intForColumnIndex:0];
                NSLog(@"id %i",totalCount);
                //[db executeUpdate:@"INSERT INTO grafo VALUES (?,?)", [NSNumber numberWithInt:totalCount+1 ],[NSNumber numberWithBool:NO]];
                
            }
            
            FMResultSet *s = [db executeQuery:@"SELECT * from iteration"/*@"SELECT count(*) FROM grafo"*/];
            NSDictionary *totalCount;
            if ([s next]) {
                //NSLog(@"GAD %lld",[s longLongIntForColumnIndex:0]);
                totalCount= [s resultDictionary];
                //NSLog(@"aaa %@",totalCount);
                // [db executeUpdate:@"INSERT INTO grafo VALUES (?,?)", [NSNumber numberWithInt:totalCount+1 ],[NSNumber numberWithBool:NO]];
                
            }
            
            
            grafo = new Graph();

            //grafo->clearGraph();
            
            FMResultSet *s2 = [db executeQuery:@"SELECT * FROM grafo where id_gr=?",idGrafo];
            
            
            while ([s2 next]) {
                grafo->clearGraph();
                resultRow = [s2 resultDictionary];
               // NSLog(@"aaa %@",resultRow);
                FMResultSet *s3 = [db executeQuery:@"SELECT * FROM nodo where grafo_n=?",[resultRow valueForKey:@"id_gr" ]];
                
                while ([s3 next]) {
                    
                    resultRow2 = [s3 resultDictionary];
                    int value=[s3 intForColumn:@"value"];
                    //NSLog(@"value %i",value);
                    grafo->newNode((char)value);
                    //NSLog(@"aaa %@",resultRow2);
                    
                    
                    
                    
                    
                }
                FMResultSet *s4 = [db executeQuery:@"SELECT * FROM arco where grafo_a=?",[resultRow valueForKey:@"id_gr"]];
                while ([s4 next]) {
                    NSDictionary *resultRow3 = [s4 resultDictionary];
                    
                    //NSNumber *value=[resultRow valueForKey:@"value"];
                    
                    grafo->newArc([s4 intForColumn:@"origen"], [s4 intForColumn:@"destino"], [s4 intForColumn:@"peso"] );
                    NSLog(@"aaa %@",resultRow3);
                }
                
                
                //retrieve values for each record
                //[resultados addObject:resultRow];
            }
            
            
            
        }
        
        
        [db close];
        
    }

    
    
    else{
        grafo = new Graph([nombreGrafo UTF8String]);

        grafo->buildGraph(numnodos, numarcos);
    }
    grafo->sortAllArcs();
    /*
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];

    
*/
        nodos=[[NSMutableArray alloc]init];
    
    //grafo = new Graph();
    //grafo->buildGraph(2, 0);
    [self dibujarGrafo];
    
   // [self guardarGrafo];

    [self drawText];
    
    //[self performSelector:@selector(dibujar) withObject:Nil afterDelay:4];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#define kBorderInset 20.0
#define kMarginInset 10.0

- (void) drawText{
    // Create URL for PDF file
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = @"test.pdf";
    NSURL *fileURL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:documentsDirectory, filename, nil]];
    

    NSString *csvPath= [documentsDirectory stringByAppendingPathComponent:@"test.csv"];

    
    // Create PDF context
    CGContextRef pdfContext = CGPDFContextCreateWithURL((CFURLRef)fileURL, NULL, NULL);
    CGPDFContextBeginPage(pdfContext, NULL);
    UIGraphicsPushContext(pdfContext);
    
    // Flip coordinate system
    CGRect bounds = CGContextGetClipBoundingBox(pdfContext);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    CGContextTranslateCTM(pdfContext, 0.0, -bounds.size.height);
    
    NSMutableString *s2=[NSMutableString string];
    
    NSMutableString *s=[NSMutableString string];
    [s appendString:@"id_grafo\tDirigido\n"];
    [s2 appendString:@"id_grafo,Dirigido\n"];
    for (NSDictionary *d in resultados) {
        [s appendString:[NSString stringWithFormat:@"%@\t\t%@\n",[d objectForKey:@"id_gr"],[d objectForKey:@"dirigido"]]];
        [s2 appendString:[NSString stringWithFormat:@"%@,%@\n",[d objectForKey:@"id_gr"],[d objectForKey:@"dirigido"]]];
    }
    [s2 writeToFile:csvPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Drawing commands
    [s drawAtPoint:CGPointMake(100, 100) withAttributes:nil];
    
    // Clean up
    UIGraphicsPopContext();
    CGPDFContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);

}
-(void)prim
{
    clock_t c1=clock();
    grafo->prim(grafo->getNode(0));
    clock_t c2=clock();
    
    
    long tiempo=c2-c1;
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"prim"];
}
-(void)dfs
{
    clock_t c1=clock();
    grafo->dfs(grafo->getNode(0));
    clock_t c2=clock();
    
    
    long tiempo=c2-c1;
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"dfs"];
}
-(void)bfs
{
    clock_t c1=clock();
    grafo->bfs(grafo->getNode(0));
    clock_t c2=clock();
    
    
    long long tiempo=c2-c1;
    NSLog(@"bfs %llu",tiempo);
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"bfs"];
}
-(void)bellman
{
    clock_t c1=clock();
    grafo->bellmanFord(grafo->getNode(0));
    clock_t c2=clock();
    
    
    long long tiempo=c2-c1;
    NSLog(@"bellman %llu",tiempo);
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"bellman"];
}
-(void)floyd
{
    clock_t c1=clock();
    grafo->floydWarshall();
    clock_t c2=clock();
    
    
    long long tiempo=c2-c1;
    NSLog(@"floyd %llu",tiempo);
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"floyd"];
}
-(void)kruskal
{
    clock_t c1=clock();
    grafo->kruskal();
    clock_t c2=clock();
    
    
    long long tiempo=c2-c1;
    NSLog(@"kruskal %llu",tiempo);
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"kruskal"];

}
-(void)dijsktra
{
    clock_t c1=clock();
    grafo->dijkstra(grafo->getNode(0));
    clock_t c2=clock();
    

    long long tiempo=c2-c1;
    NSLog(@"dijsktra %llu",tiempo);
    [tiempos setObject:[NSNumber numberWithLong:tiempo] forKey:@"dijsktra"];
    if ([db open]) {
        
        FMResultSet *s3 = [db executeQuery:@"SELECT count(*) FROM grafo"];
        
        if ([s3 next]) {
            int totalCount = [s3 intForColumnIndex:0];
            
            [db executeUpdate:@"INSERT INTO iteration (id_al,id_gr,time) VALUES (1,?,?)",[NSNumber numberWithLongLong:totalCount], [NSNumber numberWithLongLong:tiempo]];
            
            FMResultSet *s4 = [db executeQuery:@"SELECT * FROM grafo"];
            if ([s4 next]) {
                id totalCount = [s4 resultDictionary];
            }
            NSLog(@"Tiempo %llu",tiempo);
            
        }
        
        
        
    }
    
   
    
}

-(float) toDegrees: (float)angle {
    return angle * (180 / 3.141592);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
