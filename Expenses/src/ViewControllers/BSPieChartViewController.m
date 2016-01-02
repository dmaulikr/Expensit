//
//  BSPieChartViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 01/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSPieChartViewController.h"
#import "BSChartLegendCollectionViewCell.h"
#import "Tag.h"

@interface BSPieChartViewController ()

@end

@implementation BSPieChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.legendsCollectionView.alpha = 0.0;
    self.titleLabel.alpha = 0.0;
    self.doneLabel.alpha = 0.0;
    [self.doneLabel setBackgroundImage:[self cancelButtonImage] forState:UIControlStateNormal];
    self.unitLabel.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartView animate];

    self.titleLabel.transform = CGAffineTransformTranslate(self.titleLabel.transform, 0, -10);
    CGAffineTransform transform = CGAffineTransformTranslate(self.doneLabel.transform, -20, 0);
    self.doneLabel.transform = CGAffineTransformRotate(transform, -M_PI_2);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)cancelButtonImage
{
    CGSize newSize = CGSizeMake(40.0f, 40.0f);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(imageContext, YES);
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, newSize.width, newSize.height), 1, 1)];
    CGContextSetStrokeColorWithColor(imageContext, [UIColor colorWithRed:199.0/256.0 green:143.0/256.0 blue:149.0/256.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(imageContext, 1.5);
    
    CGContextAddPath(imageContext, borderPath.CGPath);
    CGContextStrokePath(imageContext);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}


/* -------------------------------------------------- PIE CHART --------------------------------------------------*/
#pragma mark - BSPieChartDelegate

- (BOOL)animatable
{
    return YES;
}

- (BOOL)clockWise
{
    return YES;
}

- (void)animationDidFinish
{
    [UIView animateWithDuration:0.5 animations:^{
        self.legendsCollectionView.alpha = 1.0;
        
        self.unitLabel.alpha = 1.0;
        
        self.titleLabel.alpha = 1.0;
        self.titleLabel.transform = CGAffineTransformIdentity;

        self.doneLabel.alpha = 1.0;
        self.doneLabel.transform = CGAffineTransformIdentity;
    }];
}



#pragma mark - BSPieChartDataSource

- (NSUInteger)numberOfSections
{
    return [self.sections count];
}

- (BSPieChartSectionInfo *)sectionInfoForIndex:(NSUInteger)index
{
    return self.sections[index];
}

- (CGFloat)sectionsWidth
{
    return 40.0f;
}

- (CGFloat)initialAngle
{
    return 3*M_PI_2;
}



/* -------------------------------------------------- LEGENDS COLLECTION VIEW --------------------------------------------------*/

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categories count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSChartLegendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PieChartLegend" forIndexPath:indexPath];
    Tag *category = self.categories[indexPath.row];
    cell.label.text = category.name;
    cell.bulletPoint.backgroundColor = category.color;
    
    return cell;
}


- (IBAction) cancelButtonPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}




- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
