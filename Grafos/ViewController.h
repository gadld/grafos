//
//  ViewController.h
//  Grafos
//
//  Created by Gad Levy on 10/7/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodoView.h"
#include "Graph.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *resultados;
    FMDatabase *db;
    
    int selectedNode1;
    int selectedNode2;
    BOOL manual;
    BOOL tiempoReal;
    UIToolbar *toolbar;
    NSMutableArray *selectedAlgorithms;
    NSMutableDictionary *tiempos;
    
    int gad;
    NSArray *algoritmos;
    int contador;
    UIView *algoritmosView;
    
    bool pausar;
    
    int **arreglo;
    
}
@property NSNumber* idGrafo;
@property NSString* nombreGrafo;
@property int numarcos;
@property (nonatomic,retain)NodoView *nodo1;
@property (nonatomic,retain)NodoView *nodo2;

@property int numnodos;

@property (nonatomic,retain)NSMutableArray *nodos;
@property Graph *grafo;
@end
