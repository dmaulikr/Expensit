//
//  BSYearlySummaryNavigationTransitionManager.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSYearlySummaryNavigationTransitionManager : BSBaseNavigationTransitionManager
{    
    func configureMonthlyExpensesViewControllerWithSegue(segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let monthlyExpensesViewController = segue.destinationViewController as! BSMonthlyExpensesSummaryViewController
        monthlyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let monthlyController = BSShowMonthlyEntriesController()
        let monthlyPresenter = BSShowMonthlyEntriesPresenter(showEntriesUserInterface: monthlyExpensesViewController, showMonthlyEntriesController: monthlyController)        
        let monthlyNavigationManager = BSMonthlySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController)
        
        monthlyExpensesViewController.showEntriesController = (monthlyController as BSAbstractShowEntriesControllerProtocol)
        monthlyExpensesViewController.showEntriesPresenter = monthlyPresenter
        monthlyExpensesViewController.showMonthlyEntriesPresenter = monthlyPresenter
        monthlyExpensesViewController.navigationTransitionManager = monthlyNavigationManager
    }
    
    func configureYearlyExpensesLineGraphViewControllerWithSegue(segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destinationViewController as! BSGraphViewController
        let yearlyLineGraphController : BSGraphLineControllerProtocol = BSYearlySummaryGraphLineController()
        let yearlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSYearlySummaryGraphLinePresenter(yearlySummaryGraphLineController: yearlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = yearlyLineGraphPresenter
    }
    
}
