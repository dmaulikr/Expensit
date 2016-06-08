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
    func configureMonthlyExpensesLineGraphViewControllerWithSegue(segue : UIStoryboardSegue, section : String)
    {
        let graphViewController = segue.destinationViewController as! BSGraphViewController
        let monthlyLineGraphController : BSGraphLineControllerProtocol = BSMonthlySummaryGraphLineController()
        let monthlyLineGraphPresenter : BSGraphLinePresenterProtocol = BSMonthlySummaryGraphLinePresenter(monthlySummaryGraphLineController: monthlyLineGraphController, section: section)
        graphViewController.lineGraphPresenter = monthlyLineGraphPresenter
    }
}