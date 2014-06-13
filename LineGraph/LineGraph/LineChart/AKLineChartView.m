
#import "AKLineChartView.h"
#define PADDING 10


@implementation AKLineComponent

- (id)init {
	self = [super init];
	if (self) {
		_labelFormat = @"%.1f%%";
	}
	return self;
}

@end



@interface AKLineChartView ()

@property (nonatomic, assign) float interval;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *infoView;

@property (nonatomic, strong) NSMutableArray *dotsArray;




@end



@implementation AKLineChartView


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:0.095 green:0.485 blue:0.858 alpha:1.000]];
        self.yLabelColor =[UIColor whiteColor];
        self.xLabelColor = [UIColor whiteColor];
		_interval = 10;
		_maxValue = 100;
		_minValue = 0;
		_yLabelFont = [UIFont fontWithName:@"Avenir-Medium" size:10];
		_xLabelFont = [UIFont fontWithName:@"Avenir-Medium" size:9];
		_valueLabelFont = [UIFont boldSystemFontOfSize:10];
		_legendFont = [UIFont boldSystemFontOfSize:10];
		_numYIntervals = 10;
		_numXIntervals = 1;
		_yLabelAlignment = NSTextAlignmentRight;
        self.autoscaleYAxis= YES;
        self.graphTitle = @"Line Graph";
        
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.viewForBaselineLayout.frame.size.height)];
        self.verticalLine.backgroundColor = [UIColor clearColor];
        self.verticalLine.alpha = .2;
        [self addSubview:self.verticalLine];
        
        self.infoView =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        [self.infoView setBackgroundColor:[UIColor whiteColor]];
        self.infoView.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
        self.infoView.textAlignment = 1;
        self.infoView.numberOfLines = 1;
        self.infoView.clipsToBounds= YES;
        self.infoView.layer.cornerRadius = 5;
        self.infoView.alpha = 0;
        [self addSubview:self.infoView];
	}
	return self;
}


//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self addXGrids];
//
//}

-(void)addXGrids
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.infoView];

    float margin = 30;
	float div_width;
	if ([self.xLabels count] == 1) {
		div_width = 0;
	} else {
		div_width = (self.frame.size.width-2*margin)/([self.xLabels count]-1);
	}

    
    
    int i =0;
    for (NSString *str in self.xLabels)
    {
        
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(margin-10 +i*div_width, self.frame.size.height-30, 30, 20)];
        [lable setTextAlignment:NSTextAlignmentRight];
        [lable setBackgroundColor:[UIColor clearColor]];
        [lable setTextColor:self.xLabelColor];
        lable.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
        lable.transform =CGAffineTransformMakeRotation(M_PI / 4);
        lable.textAlignment = 1;
        lable.numberOfLines = 1;
        lable.text = str;
        [self addSubview:lable];
        i++;
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchLocation:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouchLocation:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.infoView.alpha =0.0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.infoView.alpha =0.0;
}



-(void)handleTouchLocation:(UITouch *) touch
{
    CGPoint translation = [touch locationInView:self.viewForBaselineLayout];
    if ((translation.x + self.frame.origin.x) <= self.frame.origin.x) { // To make sure the vertical line doesn't go beyond the frame of the graph.
        self.verticalLine.frame = CGRectMake(0, 0, 2, self.viewForBaselineLayout.frame.size.height);
    } else if ((translation.x + self.frame.origin.x) >= self.frame.origin.x + self.frame.size.width) {
        self.verticalLine.frame = CGRectMake(self.frame.size.width, 0, 2, self.viewForBaselineLayout.frame.size.height);
    } else {
        self.verticalLine.frame = CGRectMake(translation.x, 0, 2, self.viewForBaselineLayout.frame.size.height);
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.verticalLine.alpha = 0.4;
    } completion:nil];
    
    
    CGPoint p = [self closestDotFromVerticalLine:self.verticalLine];
    if(CGPointEqualToPoint(p, CGPointZero))
    {
        self.infoView.alpha = 0;
        return;
    }
    p.y = p.y-20;
    self.infoView.center = p;
    self.infoView.alpha = .7;
}




- (CGPoint )closestDotFromVerticalLine:(UIView *)verticalLine
{
    int currentlyCloser;
    CGPoint closestDot;
    currentlyCloser = pow((self.frame.size.width/(self.xLabels.count-1))/2, 2);
    for (int i =0; i < self.dotsArray.count; i++)
    {
        NSValue  *value = [self.dotsArray objectAtIndex:i];
        CGPoint point =[value CGPointValue];
        if (pow(((point.x) - verticalLine.frame.origin.x), 2) < currentlyCloser)
        {
            currentlyCloser = pow(((point.x) - verticalLine.frame.origin.x), 2);
            closestDot = point;
            
            AKLineComponent *component = [self.components lastObject];
            self.infoView.text =[NSString stringWithFormat:@"%@",[component.points objectAtIndex:i]];
            [self.infoView sizeToFit];
            CGRect frame = self.infoView.frame;
            frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-2, -5, -2, -5));
            self.infoView.frame = frame;
        }
        
    }
    return closestDot;
}


- (void)drawRect:(CGRect)rect
{
    
    //Calculating the  intevals
    int min= 0,max=0;
    
    for (AKLineComponent *component in self.components)
    {
        for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
            min = MIN(min, [[component.points objectAtIndex:x_axis_index] floatValue]);
            max = MAX(max, [[component.points objectAtIndex:x_axis_index] floatValue]);
        }
    }
    _maxValue = max;
    _minValue = min;
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(ctx);
	CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f); //x and  y legends color

    
    
	int n_div;
	int power = 0;
	float scale_min, scale_max, div_height;
	float top_margin = 35;
    float margin = 30;
    float bottom_margin =10;
    if((self.frame.size.width-2*margin)/([self.xLabels count]-1) <30)
    {
        bottom_margin =20;
    }

	float x_label_height = 20;
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    UIFont *textFont = [UIFont fontWithName:@"Avenir-Medium" size:14];
    
    [self.graphTitle drawInRect:CGRectMake(0, 5, self.frame.size.width, 20) withAttributes:@{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.yLabelColor}];
#else
	[self.graphTitle drawInRect:CGRectMake(0, 5, self.frame.size.width, 20) withFont:self.yLabelFont lineBreakMode:NSLineBreakByWordWrapping alignment:self.yLabelAlignment];
#endif


	if (self.autoscaleYAxis)
    {
		scale_min = 0.0;
		power = floor(log10(self.maxValue/5));
		float increment = self.maxValue / (5 * pow(10,power));
		increment = (increment <= 5) ? ceil(increment) : 10;
		increment = increment * pow(10,power);
		scale_max = 5 * increment;
		self.interval = scale_max / self.numYIntervals;
	}
    else
    {
		scale_min = self.minValue;
		scale_max = self.maxValue;
	}
    
	n_div = (scale_max-scale_min)/self.interval + 1;
	div_height = (self.frame.size.height-top_margin-bottom_margin-x_label_height)/(n_div-1);

    //Y Lable Drawing
	for (int i=0; i<n_div; i++)
    {
		float y_axis = scale_max - i*self.interval;
		int y = top_margin + div_height*i;
		CGRect textFrame = CGRectMake(0,y-8,25,20);

		NSString *formatString = [NSString stringWithFormat:@"%%.%if", (power < 0) ? -power : 0];
		NSString *text;
		if (self.mappedYLabels != nil) {
			NSUInteger key = [[NSString stringWithFormat:formatString, y_axis] integerValue];
			text = [self.mappedYLabels objectForKey:[NSNumber numberWithInteger:key]];
		} else {
			text = [NSString stringWithFormat:formatString, y_axis];
		}
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 
        
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            UIFont *textFont = self.yLabelFont;

            [text drawInRect:textFrame withAttributes:@{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.yLabelColor}];
#else
	[text drawInRect:textFrame withFont:self.yLabelFont lineBreakMode:NSLineBreakByWordWrapping alignment:self.yLabelAlignment];
#endif
    
        

		// These are "grid" lines
		CGContextSetLineWidth(ctx, 1);
		CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.1f);
		CGContextMoveToPoint(ctx, 30, y);
		CGContextAddLineToPoint(ctx, self.frame.size.width-30, y);
		CGContextStrokePath(ctx);
	}

    
	float div_width;
	if ([self.xLabels count] == 1) {
		div_width = 0;
	} else {
		div_width = (self.frame.size.width-2*margin)/([self.xLabels count]-1);
	}
    
    /// add X grids
    for (NSUInteger i=0; i<[self.xLabels count]; i++)
    {
            int x = margin + div_width*i;
            CGContextSetLineWidth(ctx, 1);
            CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.1f);
            CGContextMoveToPoint(ctx, x, top_margin);
            CGContextAddLineToPoint(ctx, x, self.frame.size.height-top_margin-5);
            CGContextStrokePath(ctx);
    }

    if(div_width < 30)
    {
        [self addXGrids];
    }else
    {
        for (NSUInteger i=0; i<[self.xLabels count]; i++)
        {
            if (i % self.numXIntervals == 1 || self.numXIntervals==1) {
                int x = (int) (margin + div_width * i);
                
                NSString *x_label = [NSString stringWithFormat:@"%@", [self.xLabels objectAtIndex:i]];
                CGRect textFrame = CGRectMake(x-(div_width/2), self.frame.size.height - x_label_height, ceil(div_width), x_label_height);
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
                NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                textStyle.lineBreakMode = NSLineBreakByWordWrapping;
                textStyle.alignment = NSTextAlignmentCenter;
                UIFont *textFont = self.xLabelFont;
                [x_label drawInRect:textFrame withAttributes:@{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.xLabelColor}];
#else
                [x_label drawInRect:textFrame
                           withFont:self.xLabelFont
                      lineBreakMode:NSLineBreakByWordWrapping
                          alignment:NSTextAlignmentCenter];
#endif
            };
        }
        
    }


	CGColorRef shadowColor = [[UIColor clearColor] CGColor];
	CGContextSetShadowWithColor(ctx, CGSizeMake(0,-1), 1, shadowColor);

	NSMutableArray *legends = [NSMutableArray array];
    
    float circle_diameter = 10;
	float circle_stroke_width = 3;
	float line_width = 4;

    
    
    
    // Start of Shaded Path
    NSMutableArray *dotslineArray = [NSMutableArray array];
    for (AKLineComponent *component in self.components)
    {
		int last_x = 0;
		int last_y = 0;
		for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
			id object = [component.points objectAtIndex:x_axis_index];
            
			if (object!=[NSNull null] && object)
            {
				float value = [object floatValue];
                
                
				int x = margin + div_width*x_axis_index;
				int y = top_margin + (scale_max-value)/self.interval*div_height;
                
				CGRect circleRect = CGRectMake(x-circle_diameter/2, y-circle_diameter/2, circle_diameter,circle_diameter);
                CGPoint p =  CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
                [dotslineArray addObject:[NSValue valueWithCGPoint:p]];
				last_x = x;
				last_y = y;
			}
		}
	}
    // L=Path
    UIBezierPath *lineGraph = [UIBezierPath bezierPath];
    [lineGraph moveToPoint:[dotslineArray[0] CGPointValue]];
    for (NSUInteger index = 0; index < dotslineArray.count ; index++)
    {
        CGPoint p0 = [(NSValue *)dotslineArray[index ] CGPointValue];
        [lineGraph addLineToPoint:p0];
    }
    [lineGraph addLineToPoint:[(NSValue *)dotslineArray[(dotslineArray.count - 1)] CGPointValue]];
    [[UIColor colorWithRed:0.089 green:0.395 blue:0.824 alpha:.6] setFill];
    CGPoint pLast = [((NSValue *)[dotslineArray lastObject]) CGPointValue];
    [lineGraph addLineToPoint:CGPointMake(pLast.x, self.frame.size.height-bottom_margin-20)];
    pLast = [(NSValue *)dotslineArray[0] CGPointValue];
    [lineGraph addLineToPoint:CGPointMake(pLast.x, self.frame.size.height-bottom_margin-20)];
    [lineGraph closePath];
    [lineGraph fill];

    // END of Shaded Path
    
    
    
    self.dotsArray = [NSMutableArray array];
	for (AKLineComponent *component in self.components)
    {
		int last_x = 0;
		int last_y = 0;

		if (!component.colour)
        {
			component.colour = [UIColor whiteColor];
		}

		for (int x_axis_index=0; x_axis_index<[component.points count]; x_axis_index++)
        {
			id object = [component.points objectAtIndex:x_axis_index];

			if (object!=[NSNull null] && object)
            {
				float value = [object floatValue];

				CGContextSetStrokeColorWithColor(ctx, [component.colour CGColor]);
				CGContextSetLineWidth(ctx, circle_stroke_width);

				int x = margin + div_width*x_axis_index;
				int y = top_margin + (scale_max-value)/self.interval*div_height;

				CGRect circleRect = CGRectMake(x-circle_diameter/2, y-circle_diameter/2, circle_diameter,circle_diameter);
				CGContextStrokeEllipseInRect(ctx, circleRect);
				CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                
                CGPoint p =  CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
                [self.dotsArray addObject:[NSValue valueWithCGPoint:p]];

				if (last_x!=0 && last_y!=0)
                {
					float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
					float last_x1 = last_x + (circle_diameter/2) / distance * (x-last_x);
					float last_y1 = last_y + (circle_diameter/2) / distance * (y-last_y);
					float x1 = x - (circle_diameter/2) / distance * (x-last_x);
					float y1 = y - (circle_diameter/2) / distance * (y-last_y);

					CGContextSetLineWidth(ctx, line_width);
					CGContextMoveToPoint(ctx, last_x1, last_y1);
					CGContextAddLineToPoint(ctx, x1, y1);
					CGContextStrokePath(ctx);
				}

				if (x_axis_index==[component.points count]-1)
                {
					NSMutableDictionary *info = [NSMutableDictionary dictionary];
					if (component.title) {
						[info setObject:component.title forKey:@"title"];
					}
					[info setObject:[NSNumber numberWithFloat:x+circle_diameter/2+15] forKey:@"x"];
					[info setObject:[NSNumber numberWithFloat:y-10] forKey:@"y"];
					[info setObject:component.colour forKey:@"colour"];
					[legends addObject:info];
				}

				last_x = x;
				last_y = y;
			}
		}
	}
    
    
    
/*
	for (int i=0; i<[self.xLabels count]; i++)
    {
		int y_level = top_margin;

		for (int j=0; j<[self.components count]; j++) {
			NSArray *items = [[self.components objectAtIndex:j] points];
			id object = [items objectAtIndex:i];
			if (object!=[NSNull null] && object) {
				float value = [object floatValue];
				int x = margin + div_width*i;
				int y = top_margin + (scale_max-value)/self.interval*div_height;
				int y1 = y - circle_diameter/2 - self.valueLabelFont.pointSize;
				int y2 = y + circle_diameter/2;

				if ([[self.components objectAtIndex:j] shouldLabelValues]) {
					if (y1 > y_level) {
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[self.components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-25,y1, 50,20);
						[perc_label drawInRect:textFrame
													withFont:self.valueLabelFont
										 lineBreakMode:NSLineBreakByWordWrapping
												 alignment:NSTextAlignmentCenter];
						y_level = y1 + 20;
					}
					else if (y2 < y_level+20 && y2 < self.frame.size.height-top_margin-bottom_margin) {
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[self.components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-25,y2, 50,20);
						[perc_label drawInRect:textFrame
													withFont:self.valueLabelFont
										 lineBreakMode:NSLineBreakByWordWrapping
												 alignment:NSTextAlignmentCenter];
						y_level = y2 + 20;
					}
					else {
						CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						NSString *perc_label = [NSString stringWithFormat:[[self.components objectAtIndex:j] labelFormat], value];
						CGRect textFrame = CGRectMake(x-50,y-10, 50,20);
						[perc_label drawInRect:textFrame
													withFont:self.valueLabelFont
										 lineBreakMode:NSLineBreakByWordWrapping
												 alignment:NSTextAlignmentCenter];
						y_level = y1 + 20;
					}
				}
				if (y+circle_diameter/2>y_level) y_level = y+circle_diameter/2;
			}
		}
	}*/

//	NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"y" ascending:YES];
//	[legends sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
	
    // For legend
    
	//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//	float y_level = 0;
//	for (NSMutableDictionary *legend in legends)
//    {
//		UIColor *colour = [legend objectForKey:@"colour"];
//		CGContextSetFillColorWithColor(ctx, [colour CGColor]);
//
//		NSString *title = [legend objectForKey:@"title"];
//		float x = [[legend objectForKey:@"x"] floatValue];
//		float y = [[legend objectForKey:@"y"] floatValue];
//		if (y<y_level) {
//			y = y_level;
//		}
//
//		CGRect textFrame = CGRectMake(x,y,margin,15);
//		[title drawInRect:textFrame withFont:self.legendFont];
//
//		y_level = y + 15;
//	}
}






@end
