//
//  BSPieChartViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 01/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BSPieGraphPresenterProtocol;
@protocol BSPieChartDataSource;
@protocol BSPieChartDelegate;

@class BSPieChartView;

@interface BSPieChartViewController : UIViewController <BSPieChartDataSource, BSPieChartDelegate>

@property (strong, nonatomic, nullable) id<BSPieGraphPresenterProtocol> pieGraphPresenter;

@property (nonatomic, weak) IBOutlet BSPieChartView *pieChartView;

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, weak) IBOutlet UICollectionView *legendsCollectionView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIButton *doneLabel;

@property (nonatomic, weak) IBOutlet UILabel *unitLabel;


- (IBAction) cancelButtonPressed:(id)sender;

@end
