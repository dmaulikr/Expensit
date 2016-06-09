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
        let dailyLineGraphController : BSGraphLineControllerProtocol = BSDailySummaryGraphLineController()
        let dailyLineGraphPresenter : BSGraphLinePresenterProtocol = BSDailySummaryGraphLinePresenter(dailySummaryGraphLineController: dailyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = dailyLineGraphPresenter
    }
}