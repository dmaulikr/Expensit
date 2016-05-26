//
//  BSShowDailyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowDailyEntriesPresenter : BSAbstractShowEntriesPresenter, BSDailyExpensesSummaryPresenterEventsProtocol {

    var visibleSection : String = ""
    var showDailyEntriesController : BSShowDailyEntriesControllerProtocol
    
    /// Initialization
    init(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol, showDailyEntriesController : BSShowDailyEntriesControllerProtocol)
    {
        self.showDailyEntriesController = showDailyEntriesController
        super.init(showEntriesUserInterface: showEntriesUserInterface, showEntriesController: showDailyEntriesController)
    }
    
    override init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
                   showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        
        return nil // Not upported to enforce the use of the specialised init method
    }
    
    override func dataForGraphFromSuplusResultsForSection(section: String) -> [AnyObject] {
        self.visibleSection = section
        let data = self.showEntriesController.graphSurplusResultsForSection(section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data) // Get the data from cntroller
    }
    
    override func dataForGraphFromExpensesResultsForSection(section: String) -> [AnyObject]{
        self.visibleSection = section
        let data = self.showEntriesController.graphExpensesResultsForSection(section)
        return self.dataForGraphFromQueryResults(data) // let presenter subclasses massage it
    }

    override func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        let monthNumber = self.visibleSection.componentsSeparatedByString("/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDaysInMonth(monthNumber)
        var graphData = Array<NSNumber>(count: numberOfDaysInMonth.length, repeatedValue: 0)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let day = dictionary["day"] as! Int
            let dailySum = dictionary["dailySum"] as! Float
            
            if dailySum > 0 {
                graphData[day] = -dailySum
            }
        }
        
        return graphData
    }
    

    func arrayDayNumbersInMonthFromVisibleSection(section: String) -> [String]
    {
        let monthNumber = section.componentsSeparatedByString("/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDaysInMonth(monthNumber)
        let dayNumbers : [Int] = Array(1...numberOfDaysInMonth.length)
        
        return dayNumbers.map { "\($0)" }
    }
    
    /// BSDailyExpensesSummaryPresenterEventsProtocol
    func expensesByCategoryForMonth(month: Int, year : Int) -> [AnyObject]? {
        return self.showDailyEntriesController.expensesByCategoryForMonth(month, year: year)
    }
    
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.showDailyEntriesController.sortedTagsByPercentageFromSections(tags, sections: sections)
    }
    
    func categoriesForMonth(month: Int, year : Int) -> [AnyObject]? {
        return self.showDailyEntriesController.categoriesForMonth(month, year: year)
    }

}
