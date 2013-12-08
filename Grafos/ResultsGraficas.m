//
//  ResultsGraficas.m
//  Grafos
//
//  Created by Gad Levy on 11/19/13.
//  Copyright (c) 2013 Gad Levy. All rights reserved.
//

#import "ResultsGraficas.h"

#define HEIGHT_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5)

@interface ResultsGraficas ()

@end

@implementation ResultsGraficas
@synthesize arreglo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(void)export
{
    [self createPDFfromUIView:self.view saveToDocumentsWithFileName:@"grafica.pdf"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:@"grafica.pdf"];
    
    
    
    NSMutableData *myPdfData = [NSMutableData dataWithContentsOfFile:pdfFileName];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Subject Goes Here."];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        [mailViewController addAttachmentData:myPdfData mimeType:@"application/pdf" fileName:pdfFileName];
        [self presentViewController:mailViewController animated:YES completion:NULL];
        
    }
  
    

    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)viewDidLoad
{
    UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 435+88*IS_IPHONE_5, 320, 40)];
    UIBarButtonItem *algoritmo=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(export)];
    
    self.navigationItem.rightBarButtonItem=algoritmo;
    [toolbar setItems:[NSArray arrayWithObject:algoritmo]];
    //[self.view addSubview:toolbar];
    
    
    /*
    PNChart * barChart = [[PNChart alloc] initWithFrame:CGRectMake(0, 200.0, 300, 200.0)];
   // barChart
    barChart.type = PNBarType;
    [barChart setXLabels:[arreglo allKeys]];
    [barChart setYValues:[arreglo allValues]];
    [barChart strokeChart];
    
    //By strokeColor you can change the chart color
    [barChart setStrokeColor:[UIColor greenColor]];
    
    [self.view addSubview:barChart];

     */
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
