//
//  Menu.h
//  Grafos
//
//  Created by Gad Levy on 11/8/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSliderPopover.h"
#import "FMDatabase.h"
@interface Menu : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet NYSliderPopover *numNodos;
    IBOutlet NYSliderPopover *numArcos;
    IBOutlet UITableView *tableView;
    UITextField *nombre;
    NSMutableArray *grafos;
    
    
    NSMutableDictionary *dict;
    FMDatabase *db;
}
-(void)numNodosValueChanged:(UISlider *)s;
-(IBAction)generarGrafo:(id)sender;
@end
