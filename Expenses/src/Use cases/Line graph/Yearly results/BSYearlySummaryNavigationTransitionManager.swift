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
    func configureMonthlyExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let monthlyExpensesViewController = segue.destinationViewController as! BSMonthlyExpensesSummaryViewController
        monthlyExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let monthlyController = BSShowMonthlyEntriesController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let monthlyPresenter = BSShowMonthlyEntriesPresenter(showEntriesUserInterface: monthlyExpensesViewController, showEntriesController: monthlyController)
        let monthlyNavigationManager = BSMonthlySummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController)
        
        monthlyExpensesViewController.showEntriesController = (monthlyController as BSAbstractShowEntriesControllerProtocol)
        monthlyExpensesViewController.showEntriesPresenter = monthlyPresenter        
        monthlyExpensesViewController.navigationTransitionManager = monthlyNavigationManager
    }
    
    func configureYearlyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destinationViewController as! BSGraphViewController
        let yearlyLineGraphController : BSGraphLineControllerProtocol = BSYearlySummaryGraphLineController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let yearlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSYearlySummaryGraphLinePresenter(yearlySummaryGraphLineController: yearlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = yearlyLineGraphPresenter
    }
    
}
