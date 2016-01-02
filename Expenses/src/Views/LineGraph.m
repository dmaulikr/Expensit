//
//  MyView.m
//  lineCharts
//
//  Created by Borja Arias Drake on 02/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "LineGraph.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kGraphLeftMargin = 40.0f;
//static const CGFloat kGraphLeftPadding = 5.0f;
static const CGFloat kGraphRightMargin = 15.0f;
static const CGFloat kGraphTopMargin = 20.0f;
static const CGFloat kGraphBottomMargin = 20.0f;
static const CGFloat kGraphDrawableAreaTopMargin = 20.0f; // This is inside the grid, so the lines don't reach the top of the grid
static const CGFloat kGraphXValuesTopMargin = 5.0f;

@interface LineGraph()

//@property (retain, nonatomic) UIColor* backgroundColor;
@property (retain, nonatomic) UIColor* backgroundVerticalLinesColor;
@property (retain, nonatomic) UIColor* backgroundHorizontalLinesColor;
@property (retain, nonatomic) UIColor* expensesLineColor;
@property (retain, nonatomic) UIColor* benefitsLineColor;
@end



@implementation LineGraph



#pragma mark - Init Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    /*************************************************************************************************/
    /* Init Method.                                                                                  */
    /*************************************************************************************************/
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Set the colors
        UIColor* lightGray = [UIColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:0.4];
        _benefitsLineColor = [UIColor colorWithRed:168.0/255.0 green:209.0/255.0 blue:141.0/255.0 alpha:1.0];
        _expensesLineColor = [UIColor colorWithRed:209.0/255.0 green:91.0/255.0 blue:82.0/255.0 alpha:1.0];
        _backgroundHorizontalLinesColor = lightGray;
        _backgroundVerticalLinesColor = lightGray;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}



#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{    
    /*************************************************************************************************/
    /* Custom drawing code.                                                                          */
    /*************************************************************************************************/
    // DEFINE DRAWABLE AREAS
    CGRect backgroundRect = rect;
    CGRect gridRect = CGRectMake(kGraphLeftMargin,
                                 kGraphTopMargin,
                                 self.bounds.size.width - kGraphLeftMargin - kGraphRightMargin,
                                 self.bounds.size.height - kGraphTopMargin - kGraphBottomMargin);
    
    CGRect graphsRect = CGRectMake(kGraphLeftMargin,
                                   kGraphTopMargin,
                                   self.bounds.size.width - kGraphLeftMargin - kGraphRightMargin,
                                   self.bounds.size.height - kGraphTopMargin - kGraphBottomMargin - kGraphDrawableAreaTopMargin);

    
    // MODIFY DATA FOR DRAWING
    NSMutableArray *benefits = [[self.dataSource moneyIn] mutableCopy];
    NSMutableArray *expenses = [[self.dataSource moneyOut] mutableCopy];
    
    if (!benefits || !expenses) {
        return;
    }
    
    
    // Calculate the maxmimum from the input values
    NSMutableArray *maxArray = [NSMutableArray array];
    NSNumber *benefitsMax = [benefits valueForKeyPath:@"@max.self"];
    NSNumber *expensesMax = [expenses valueForKeyPath:@"@max.self"];
    
    if (benefitsMax) {
        [maxArray addObject:benefitsMax];
    }

    if (expensesMax) {
        [maxArray addObject:expensesMax];
    }
    
    CGFloat maxDomainValue = [[maxArray valueForKeyPath:@"@max.self"] floatValue];
    NSMutableArray *pointsIn = [self pointsInGraphicDomainFromUserDomainValues:benefits graphRect:graphsRect maxUserDomainValue:maxDomainValue];
    NSMutableArray *pointsOut = [self pointsInGraphicDomainFromUserDomainValues:expenses graphRect:graphsRect maxUserDomainValue:maxDomainValue];
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(theContext);
        // MOVE THE ORIGIN TO THE LEFT BOTTOM CORNER
        CGContextTranslateCTM(theContext, 0, self.bounds.size.height);
        CGContextScaleCTM(theContext, 1, -1);
        
        // DRAW BACKGROUND + GRID
        [self drawBackgroundInRect:backgroundRect];
        [self drawGridInRect:gridRect horizontalLines:9 verticalLines:[benefits count] xValues:self.dataSource.xValues maxYValue:maxDomainValue];

        // MOVE ORIGIN TO BE AT THE INTERSECTION OF THE AXIS
        CGContextTranslateCTM(theContext, kGraphLeftMargin, kGraphBottomMargin);
        
        // Create the paths
        if ([benefits count]>0 || [expenses count]>0) {
            NSArray *subpaths = [self intersectionSubpathsBenefitPoints:pointsIn expensePoints:pointsOut]; // This method modifies points In and Out to include the intersection points
            
            // Stroke the new paths
            [self strokeGraphLineWithPoints:pointsIn andLength:[pointsIn count] lineColor:self.benefitsLineColor];
            [self strokeGraphLineWithPoints:pointsOut andLength:[pointsOut count] lineColor:self.expensesLineColor];
        
            // Draw the intersection paths
            [self drawIntersectionPaths:subpaths];
        }
    
    

    CGContextRestoreGState(theContext);
}



#pragma mark - Transformation of the user data into points

- (NSMutableArray *) pointsInGraphicDomainFromUserDomainValues:(NSArray *)userDomainValues graphRect:(CGRect)graphsRect maxUserDomainValue:(CGFloat)maxUserDomainValue
{
    NSMutableArray *points = [NSMutableArray array];
    CGFloat numberOfHorizontalPoints = [userDomainValues count];
    CGFloat sum = 0; // Horizontal sum so we can create the horizontal
    CGFloat step = graphsRect.size.width / (numberOfHorizontalPoints - 1); // Amount in graphic space that separates the x components of the points
    CGFloat maxPhysicalHeight = graphsRect.size.height;
    CGFloat scalingFactor = (maxPhysicalHeight / maxUserDomainValue); // To convert between the user and the graphic domains
    
    // Special cases when there's no or little data
    if (numberOfHorizontalPoints == 1)
    {
        step = 0;
        sum = (graphsRect.size.width / 2.0);
    }
    
    for (int i = 0; i< numberOfHorizontalPoints; i++)
    {
        CGPoint point = CGPointZero;
        point.x = sum;
        point.y = [userDomainValues[i] floatValue] * scalingFactor;
        points[i] = [NSValue valueWithCGPoint:point];
        sum += step;
    }
    
    return points;
}



#pragma mark - Calculation Of intersection subpaths

- (int) gradientBetweenMoneyIn:(CGPoint)moneyIn andMoneyOut:(CGPoint)moneyOut
{
    return (moneyIn.y > moneyOut.y) ? 1 : (moneyIn.y < moneyOut.y) ? -1 : 0;
}


- (NSArray *) intersectionSubpathsBenefitPoints:(NSMutableArray *)pointsIn expensePoints:(NSMutableArray *)pointsOut
{
    if ([pointsIn count]<=0 || [pointsOut count]<=0) {
        return nil;
    }
    
    NSMutableArray *subpaths = [[NSMutableArray alloc] init];
    
    int lastGradient = [self gradientBetweenMoneyIn:[(NSValue*)pointsIn[0] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[0] CGPointValue]];
    int index = 1;
    int initialSubpathIndex = 0;
    //int numberOfOriginalPoints = [pointsIn count];
    
    while (index < [pointsIn count])
    {
        int currentPairGradient = [self gradientBetweenMoneyIn:[pointsIn[index] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[index] CGPointValue]];
        
        if ((lastGradient != 0) && (lastGradient != currentPairGradient))
        {
            // There's an interecsection
            CGPoint intersectionPoint = CGPointZero;
            if (currentPairGradient == 0) {
                intersectionPoint = [pointsIn[index] CGPointValue];
            } else {
                intersectionPoint = [self intersectionPointBwetweenWithFirstLineFirstPoint:[pointsIn[index-1] CGPointValue]
                                                                      firstLineSecondPoint:[pointsIn[index] CGPointValue]
                                                                      secondLineFirstPoint:[pointsOut[index-1] CGPointValue]
                                                                     secondLineSecondPoint:[pointsOut[index] CGPointValue]];
            }
            
            if (currentPairGradient != 0 )
            {
                [pointsIn insertObject:[NSValue valueWithCGPoint:intersectionPoint] atIndex:index];
                [pointsOut insertObject:[NSValue valueWithCGPoint:intersectionPoint] atIndex:index];
            }
            
            [self addNewSubpathTo:subpaths withMoneyIn:pointsIn moneyOut:pointsOut initialSubPathIndex:initialSubpathIndex currentIndex:index gradient:lastGradient];
            lastGradient = [self gradientBetweenMoneyIn:[(NSValue*)pointsIn[index] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[index] CGPointValue]];// isn't it alwyas 0 after an intersection?
            
            
            initialSubpathIndex = index;
        }
        else
        {
            // There's no change
            
            lastGradient = currentPairGradient;
        }
        
        index++;
        
    }
    
    if (lastGradient != 0 )
    {
        // we need to add the last path
        [self addNewSubpathTo:subpaths withMoneyIn:pointsIn moneyOut:pointsOut initialSubPathIndex:initialSubpathIndex currentIndex:[pointsIn count]-(NSUInteger)1 gradient:lastGradient];
    }
    
    return subpaths;
}


- (CGPoint) intersectionPointBwetweenWithFirstLineFirstPoint:(CGPoint)firstLineFirstPoint
                                        firstLineSecondPoint:(CGPoint)firstLineSecondPoint
                                        secondLineFirstPoint:(CGPoint)secondLineFirstPoint
                                       secondLineSecondPoint:(CGPoint)secondLineSecondPoint {
    
    //Calculate Line1 equation
    CGFloat L1_a = (firstLineSecondPoint.y - firstLineFirstPoint.y) / (firstLineSecondPoint.x - firstLineFirstPoint.x);
    CGFloat L1_b = firstLineFirstPoint.y - (L1_a * firstLineFirstPoint.x);
    
    //Calculate Line2 equation
    CGFloat L2_a = (secondLineSecondPoint.y - secondLineFirstPoint.y) / (secondLineSecondPoint.x - secondLineFirstPoint.x);
    CGFloat L2_b = secondLineFirstPoint.y - (L2_a * secondLineFirstPoint.x);
    
    // Calculate IPx
    CGFloat IPx = (L2_b - L1_b) / (L1_a - L2_a);
    
    // Calculate IPy, using the first line for example
    CGFloat IPy = L1_a * IPx + L1_b;
    
    return CGPointMake(IPx, IPy);
}


- (void) addNewSubpathTo:(NSMutableArray*)subpaths withMoneyIn:(NSMutableArray*)moneyIn moneyOut:(NSMutableArray*)moneyOut initialSubPathIndex:(NSUInteger)initialIndex currentIndex:(NSInteger)currentIndex gradient:(NSInteger)gradient
{
    UIBezierPath *subpath = [UIBezierPath bezierPath];
    CGPoint initialPoint = [moneyIn[initialIndex] CGPointValue];
    [subpath moveToPoint:initialPoint];
    
    NSInteger initialLoopValue = initialIndex;
    if (initialIndex+1 < [moneyIn count]) {
        initialLoopValue = initialIndex + 1;
    }
    
    for (NSInteger i = initialLoopValue ; i<=currentIndex; i++) {
        [subpath addLineToPoint:[(NSValue*)moneyIn[i] CGPointValue]];
    }
    
    
    
    for (NSInteger i = currentIndex ; ABS(i-initialIndex)>0; i--) {
        if (i >= 0 && i < moneyOut.count) {
            [subpath addLineToPoint:[(NSValue*)moneyOut[i] CGPointValue]];
        }

    }
    
    if (!CGPointEqualToPoint([(NSValue*)moneyIn[initialIndex] CGPointValue], [(NSValue*)moneyOut[initialIndex] CGPointValue])) {
        [subpath addLineToPoint:[(NSValue*)moneyIn[initialIndex] CGPointValue]];
    }
    
    [subpaths addObject:@{@"path" :subpath, @"gradient" : @(gradient)}];
}



#pragma mark - Drawing Helpers

- (void) drawIntersectionPaths:(NSArray *)subpaths
{
    for (NSDictionary *subpathDic in subpaths)
    {
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        [subpathDic[@"path"] addClip];
        // Draw a gradient
        CGPoint startPoint = CGPointMake(0.0, 0.0);
        CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);
        
        if ([subpathDic[@"gradient"] integerValue] > 0)
        {
            CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self greenGraphAreaGradient], startPoint, endPoint, 0);
        } else
        {
            CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self redGraphAreaGradient], startPoint, endPoint, 0);
        }
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}


- (void) strokeGraphLineWithPoints:(NSArray*)points andLength:(NSUInteger)length lineColor:(UIColor*)lineColor
{
    /*************************************************************************************************/
    /* Creates a path following the points in point and stroke them.                                 */
    /*************************************************************************************************/
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
        const CGFloat *colors = CGColorGetComponents( lineColor.CGColor );
        CGContextSetRGBStrokeColor(con, colors[0], colors[1], colors[2], 1.0);
        CGContextSetLineWidth(con, 1.5);
        CGContextSetLineJoin(con, kCGLineJoinRound);
    
        // Create the visible part of the graph and stroke it
    CGPoint point = CGPointZero;
        if ([points count] > 0) {
            point = [(NSValue*)points[0] CGPointValue];
            CGContextMoveToPoint(con, point.x, point.y);
        }
    
        for (NSInteger i=1; i<length; i++)
        {
            point = [(NSValue*)points[i] CGPointValue];
            CGContextAddLineToPoint(con, point.x, point.y);
        }
    
        if (length == 1)
        {
            CGContextAddEllipseInRect(con, CGRectMake(point.x - 5 , point.y -5, 5, 5));
        }
        
        CGContextStrokePath(con);
    
    CGContextRestoreGState(con);
}


- (void) drawBackgroundInRect:(CGRect)rect
{
    /*************************************************************************************************/
    /* sets the Background color and draws the grid.                                                 */
    /*************************************************************************************************/
    // Round the corners
    UIBezierPath* roundedCornersPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(16.0, 16.0)];
    [roundedCornersPath addClip];
    
    // Draw a gradient
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self backgroundGradient], startPoint, endPoint, 0);
}


- (void) drawGridInRect:(CGRect)rect horizontalLines:(NSUInteger)horizontalLines verticalLines:(NSUInteger)verticalLines xValues:(NSArray *)xValues maxYValue:(CGFloat)maxYValue
{
    [self drawVerticalBackgroundLinesInRect:rect numberOfLines:verticalLines color:self.backgroundVerticalLinesColor xValuesNames:xValues];
    [self drawHorizontalBackgroundLinesInRect:rect numberOfLines:horizontalLines color:self.backgroundHorizontalLinesColor lineWidth:0.5 dashed:YES maxYValue:maxYValue];
}


- (CGGradientRef) backgroundGradient
{
    CGFloat colors[16] = {28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0};

    CGFloat locations[4] = {0.0, 0.5f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


- (CGGradientRef) greenGraphAreaGradient
{
    CGFloat colors[16] = {17.0/255, 49.0/255, 16.0/255, 0.6,
                          27.0/255, 78.0/255, 25.0/255, 0.1,
                          27.0/255, 78.0/255, 25.0/255, 0.2,
                          119.0/255, 193.0/255, 112.0/255, 0.9};
    CGFloat locations[4] = {0.0, 0.25f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


- (CGGradientRef) redGraphAreaGradient
{
    CGFloat colors[16] = {248.0/255, 213.0/255, 200.0/255, 0.1,
        248.0/255, 213.0/255, 200.0/255, 0.1,
        209.0/255, 151.0/255, 136.0/255, 0.2,
        209.0/255, 107.0/255, 101.0/255, 0.9};
    CGFloat locations[4] = {0.0, 0.25f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


- (void) drawVerticalBackgroundLinesInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines color:(UIColor*)color xValuesNames:(NSArray *)xvalues
{
    /*************************************************************************************************/
    /*                                                                                               */
    /*************************************************************************************************/
    NSInteger numberOfRegions = numberOfLines - 1; // because we're creating lines at the edges too.
    CGFloat distanceBetweenLines = (rect.size.width / (float)numberOfRegions);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);

    CGContextTranslateCTM(con, CGRectGetMinX(rect), self.bounds.size.height);
    CGContextScaleCTM(con, 1, -1);

//    [self.dataSource.graphTitle drawAtPoint:CGPointMake((rect.size.width/2.0)-10, 5) forWidth:50 withFont:[UIFont systemFontOfSize:10] fontSize:10 lineBreakMode:NSLineBreakByTruncatingTail baselineAdjustment:UIBaselineAdjustmentNone];
        [self.dataSource.graphTitle drawAtPoint:CGPointMake((rect.size.width/2.0)-10, 5) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                                                         NSForegroundColorAttributeName : [UIColor whiteColor] }];
        UIBezierPath* verticalLinePath = [UIBezierPath bezierPath];
    
        // Draw the first line
        [color setStroke];
        [verticalLinePath setLineWidth:0.5];
        [verticalLinePath moveToPoint:CGPointMake(0, CGRectGetMinY(rect))];
        [verticalLinePath addLineToPoint:CGPointMake(0, CGRectGetMaxY(rect))];
        [verticalLinePath stroke];

        if ([xvalues count] > 0) {
//            [self.dataSource.graphTitle drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin)
//                                           forWidth:50
//                                           withFont:[UIFont systemFontOfSize:7]
//                                           fontSize:7
//                                      lineBreakMode:NSLineBreakByTruncatingTail
//                                 baselineAdjustment:UIBaselineAdjustmentNone];

            [xvalues[0] drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:7],
                                                                                                                   NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }

        for (int i=1; i<numberOfLines-1; i++)
        {
            // Draw line
            CGContextTranslateCTM(con, distanceBetweenLines, 0.0);
            [color setStroke];
            [verticalLinePath stroke];

//            [self.dataSource.graphTitle drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin)
//                                           forWidth:50
//                                           withFont:[UIFont systemFontOfSize:7]
//                                           fontSize:7
//                                      lineBreakMode:NSLineBreakByTruncatingTail
//                                 baselineAdjustment:UIBaselineAdjustmentNone];

            [xvalues[i] drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:7],
                                                                           NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
    
        // Draw the last line
        CGContextTranslateCTM(con, distanceBetweenLines, 0.0);
        [color setStroke];
        [verticalLinePath stroke];
    
//    [self.dataSource.graphTitle drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin)
//                                   forWidth:50
//                                   withFont:[UIFont systemFontOfSize:7]
//                                   fontSize:7
//                              lineBreakMode:NSLineBreakByTruncatingTail
//                         baselineAdjustment:UIBaselineAdjustmentNone];

        [[xvalues lastObject] drawAtPoint:CGPointMake(-5, CGRectGetMaxY(rect) + kGraphXValuesTopMargin) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:7],
                                                                                                           NSForegroundColorAttributeName : [UIColor whiteColor] }];

    CGContextRestoreGState(con);
}


- (void) drawHorizontalBackgroundLinesInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines color:(UIColor*)color lineWidth:(CGFloat)lineWidth dashed:(BOOL)dashed maxYValue:(CGFloat)maxYValue
{
    /*************************************************************************************************/
    /*                                                                                               */
    /*************************************************************************************************/
    CGFloat graphicDomainToUserDomainScalingFactor = (maxYValue / rect.size.height);
    NSInteger numberOfRegions = numberOfLines-1; // because we're creating lines at the edges too.
    CGFloat userDomainExtra = kGraphDrawableAreaTopMargin * graphicDomainToUserDomainScalingFactor;//maxYValue - ((rect.size.height - kGraphDrawableAreaTopMargin) * ((float)maxYValue / (float)rect.size.height));
    CGFloat graphMaxYUserDomain = maxYValue + userDomainExtra;
    CGFloat distanceBetweenLines = (rect.size.height / numberOfRegions);
    CGFloat yValuesStep = graphMaxYUserDomain / (float)numberOfRegions;
    CGFloat yValueIncrement = 0;
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
        UIBezierPath* horizontalLinePath = [UIBezierPath bezierPath];
        [[color colorWithAlphaComponent:0.3] setStroke];
        [horizontalLinePath setLineWidth:lineWidth];
        [horizontalLinePath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        [horizontalLinePath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        [horizontalLinePath stroke];
            
        if (dashed)
        {
            const CGFloat sizes[2] = {3, 2};
            [horizontalLinePath setLineDash:sizes count:2 phase:0.0];
        }
        
        for (int i=1; i<numberOfLines; i++)
        {
            // Draw line
            CGContextTranslateCTM(con, 0.0, distanceBetweenLines);
            [horizontalLinePath stroke];
            
            CGContextSaveGState(con);
                CGContextScaleCTM(con, 1, -1);
            

//            [[self.currencyFormatter formattedStringForNumber:@(yValueIncrement)] drawAtPoint:CGPointMake(5, 10)  forWidth:50 withFont:[UIFont systemFontOfSize:7] fontSize:7 lineBreakMode:NSLineBreakByTruncatingTail baselineAdjustment:UIBaselineAdjustmentNone];
            
                [[NSString stringWithFormat:@"%@", [self.currencyFormatter formattedStringForNumber:@(yValueIncrement)]] drawAtPoint:CGPointMake(5, 10) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:7],
                                                                                                                    NSForegroundColorAttributeName : [UIColor whiteColor] }];
            CGContextRestoreGState(con);
            
            yValueIncrement += yValuesStep;
        }
    
    CGContextTranslateCTM(con, 0.0, distanceBetweenLines);
    CGContextSaveGState(con);
    CGContextScaleCTM(con, 1, -1);
    
//    [[self.currencyFormatter formattedStringForNumber:@(yValueIncrement)] drawAtPoint:CGPointMake(5, 10)  forWidth:50 withFont:[UIFont systemFontOfSize:7] fontSize:7 lineBreakMode:NSLineBreakByTruncatingTail baselineAdjustment:UIBaselineAdjustmentNone];

    [[NSString stringWithFormat:@"%@", [self.currencyFormatter formattedStringForNumber:@(yValueIncrement)]] drawAtPoint:CGPointMake(5, 10) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:7],
                                                                                                             NSForegroundColorAttributeName : [UIColor whiteColor] }];
    CGContextRestoreGState(con);

    
    CGContextRestoreGState(con);
}




#pragma mark - Memory Management

- (void)dealloc
{
    /*************************************************************************************************/
    /* Tidy-Up                                                                                       */
    /*************************************************************************************************/
    
}

@end
