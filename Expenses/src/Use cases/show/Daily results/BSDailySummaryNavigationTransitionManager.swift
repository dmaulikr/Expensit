//
//  BSDailySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

import UIKit

class BSDailySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    func configureDailyExpensesLineGraphViewControllerWithSegue(segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destinationViewController as! BSGraphViewController
        let dailyLineGraphController : BSGraphLineControllerProtocol = BSDailySummaryGraphLineController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let dailyLineGraphPresenter : BSGraphLinePresenterProtocol = BSDailySummaryGraphLinePresenter(dailySummaryGraphLineController: dailyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = dailyLineGraphPresenter
    }

    func configureMonthlyExpensesPieGraphViewControllerWithSegue(segue : UIStoryboardSegue, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate)
    {
        let graphViewController = segue.destinationViewController as! BSPieChartViewController
        graphViewController.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = .Custom;
        
        let pieGraphController : BSPieGraphControllerProtocol = BSExpensesSummaryPieGraphController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let pieGraphPresenter : BSPieGraphPresenterProtocol = BSExpensesSummaryPieGraphPresenter(pieGraphController: pieGraphController, month: month, year: year)
        graphViewController.pieGraphPresenter = pieGraphPresenter
    }

}