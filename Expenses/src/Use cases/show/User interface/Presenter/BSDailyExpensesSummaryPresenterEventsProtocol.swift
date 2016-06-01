//
//  BSDailyExpensesSummaryPresenterEventsProtocol.swift
//  Expenses
//
//  Created by Borja Arias Drake on 23/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc protocol BSDailyExpensesSummaryPresenterEventsProtocol : BSAbstractExpensesSummaryPresenterEventsProtocol {
    func expensesByCategoryForMonth(month: Int, year : Int) -> [AnyObject]?
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]?
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]?
    func arrayDayNumbersInMonthFromVisibleSection(section: String) -> [String]
    func sectionNameForSelectedIndexPath(indexPath : NSIndexPath, sectionTitle: String) -> String
}
