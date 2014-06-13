//
//  ViewController.h
//  LineGraph
//
//  Created by Avinash on 6/13/14.
//  Copyright (c) 2014 avanitechnologies. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AKLineComponent : NSObject
@property (nonatomic, assign) BOOL shouldLabelValues;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UIColor *colour;
@property (nonatomic, copy) NSString *title, *labelFormat;
@end


@interface AKLineChartView : UIView


@property (nonatomic, strong) NSMutableArray *components, *xLabels;

@property (nonatomic, strong) UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;
@property (nonatomic, strong) UIColor *yLabelColor, *xLabelColor;
@property (nonatomic, strong) NSString *graphTitle;

@property (nonatomic, assign) BOOL autoscaleYAxis;
@property (nonatomic, assign) NSUInteger numYIntervals; // Use n*5 for best results
@property (nonatomic, assign) NSUInteger numXIntervals;
@property (nonatomic, strong) NSDictionary *mappedYLabels;
@property (nonatomic) NSTextAlignment yLabelAlignment;

@end
