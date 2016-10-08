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
    func configureDailyExpensesLineGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destination as! BSGraphViewController
        let dailyLineGraphController : BSGraphLineControllerProtocol = BSDailySummaryGraphLineController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let dailyLineGraphPresenter : BSGraphLinePresenterProtocol = BSDailySummaryGraphLinePresenter(dailySummaryGraphLineController: dailyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = dailyLineGraphPresenter
    }

    func configureMonthlyExpensesPieGraphViewControllerWithSegue(_ segue : UIStoryboardSegue, month : NSNumber?, year: Int, animatedBlurEffectTransitioningDelegate: BSAnimatedBlurEffectTransitioningDelegate)
    {
        let graphViewController = segue.destination as! BSPieChartViewController
        graphViewController.transitioningDelegate = animatedBlurEffectTransitioningDelegate;
        graphViewController.modalPresentationStyle = .custom;
        
        let pieGraphController : BSPieGraphControllerProtocol = BSExpensesSummaryPieGraphController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let pieGraphPresenter : BSPieGraphPresenterProtocol = BSExpensesSummaryPieGraphPresenter(pieGraphController: pieGraphController, month: month, year: NSNumber(integerLiteral: year))
        graphViewController.pieGraphPresenter = pieGraphPresenter
    }
    
    func configureAllExpensesViewControllerWithSegue(_ segue : UIStoryboardSegue, nameOfSectionToBeShown : String)
    {
        let allExpensesViewController = segue.destination as! BSIndividualExpensesSummaryViewController
        allExpensesViewController.nameOfSectionToBeShown = nameOfSectionToBeShown;
        let dailyNavigationManager = BSIndividualEntriesSummaryNavigationTransitionManager(coreDataStackHelper: self.coreDataStackHelper, coreDataController: self.coreDataController)
        allExpensesViewController.navigationTransitionManager = dailyNavigationManager
        let allController = BSShowAllEntriesController(coreDataStackHelper : self.coreDataStackHelper, coreDataController : self.coreDataController)
        let allPresenter = BSShowAllEntriesPresenter(showEntriesUserInterface: allExpensesViewController, showEntriesController: allController)
                
        allExpensesViewController.showEntriesController = (allController as BSAbstractShowEntriesControllerProtocol)
        allExpensesViewController.showEntriesPresenter = allPresenter
        
    }


}
