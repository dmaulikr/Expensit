//
//  BSMonthlySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSMonthlySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{
    
    func configureDailyExpensesViewControllerWithSegue(segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let dailyExpensesViewController = segue.destinationViewController as! BSDailyExpensesSummaryViewController
        dailyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let dailyController = BSShowDailyEntriesController()
        let dailyPresenter = BSShowDailyEntriesPresenter(showEntriesUserInterface: dailyExpensesViewController, showDailyEntriesController: dailyController)
        let dailyNavigationManager = BSDailySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController)
        
        dailyExpensesViewController.showEntriesController = (dailyController as BSAbstractShowEntriesControllerProtocol)
        dailyExpensesViewController.showEntriesPresenter = dailyPresenter
        dailyExpensesViewController.showDailyEntriesPresenter = dailyPresenter
        dailyExpensesViewController.navigationTransitionManager = dailyNavigationManager
    }
    
    func configureMonthlyExpensesLineGraphViewControllerWithSegue(segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destinationViewController as! BSGraphViewController
        let monthlyLineGraphController : BSGraphLineControllerProtocol = BSMonthlySummaryGraphLineController()
        let monthlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSMonthlySummaryGraphLinePresenter(monthlySummaryGraphLineController: monthlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = monthlyLineGraphPresenter
    }
}