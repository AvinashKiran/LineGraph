//
//  ViewController.m
//  LineGraph
//
//  Created by Flatmind on 6/13/14.
//  Copyright (c) 2014 avanitechnologies. All rights reserved.
//

#import "ViewController.h"
#import "AKLineChartView.h"

@interface ViewController ()

@property (nonatomic, strong) AKLineChartView *lineChartView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpGraph];
}


-(void)setUpGraph
{
    _lineChartView = [[AKLineChartView alloc] initWithFrame:CGRectMake(10,100,[self.view bounds].size.width-20,[self.view bounds].size.width-20)];
    [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_lineChartView];
    
    AKLineComponent *component = [[AKLineComponent alloc] init];
    [component setTitle:@""];
    [component setPoints:@[[NSNumber numberWithInt:10],[NSNumber numberWithInt:50],[NSNumber numberWithInt:20],[NSNumber numberWithInt:150],[NSNumber numberWithInt:105],[NSNumber numberWithInt:80],[NSNumber numberWithInt:10],[NSNumber numberWithInt:50],[NSNumber numberWithInt:20],[NSNumber numberWithInt:150],[NSNumber numberWithInt:105],[NSNumber numberWithInt:80]]];
    [component setShouldLabelValues:YES];
    [component setColour:[UIColor whiteColor]];
    [_lineChartView setComponents:(NSMutableArray *)@[component]];
    [_lineChartView setXLabels:(NSMutableArray *)@[@"JANUARy",@"FEB",@"MAR",@"APR",@"MAY",@"JUNE",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"]];
    
    
//    [component setPoints:@[[NSNumber numberWithInt:10],[NSNumber numberWithInt:50],[NSNumber numberWithInt:20],[NSNumber numberWithInt:150],[NSNumber numberWithInt:105],[NSNumber numberWithInt:80]]];
//    [component setShouldLabelValues:YES];
//    [component setColour:[UIColor whiteColor]];
//    [_lineChartView setComponents:(NSMutableArray *)@[component]];
//    [_lineChartView setXLabels:(NSMutableArray *)@[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUNE",]];

    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
