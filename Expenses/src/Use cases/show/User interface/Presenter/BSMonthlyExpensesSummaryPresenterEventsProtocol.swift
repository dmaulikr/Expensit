//
//  BSMonthlyExpensesSummaryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 22/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc protocol BSMonthlyExpensesSummaryPresenterEventsProtocol : BSAbstractExpensesSummaryPresenterEventsProtocol {
    func expensesByCategoryForMonth(month: Int, year : Int) -> [AnyObject]?
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]?
    func categoriesForMonth(month: Int, year : Int) -> [AnyObject]?
}
