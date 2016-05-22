//
//  BSShowMonthlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowMonthlyEntriesPresenter : BSAbstractShowEntriesPresenter, BSMonthlyExpensesSummaryPresenterEventsProtocol {

    var showMonthlyEntriesController : BSShowMonthlyEntriesControllerProtocol
    
    
    init(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
         showMonthlyEntriesController : BSShowMonthlyEntriesControllerProtocol) {
        
        self.showMonthlyEntriesController = showMonthlyEntriesController
        
        super.init(showEntriesUserInterface: showEntriesUserInterface,
                   showEntriesController : showMonthlyEntriesController)
    }

    override init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
         showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        
        return nil // Not upported to enforce the use of the specialised init method
    }


    
    override func abscissaValues() -> [String] {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }
    
    override func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        var graphData = Array<NSNumber>(count: 12, repeatedValue: 0)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let month = dictionary["month"] as! Int
            let monthlySum = dictionary["monthlySum"] as! Float
            
            if monthlySum > 0 {
                graphData[month] = -monthlySum
            }
        }
        
        return graphData
    }
    
    /// BSMonthlyExpensesSummaryPresenterEventsProtocol
    func expensesByCategoryForMonth(month: Int, year : Int) -> [AnyObject]? {
        return self.showMonthlyEntriesController.expensesByCategoryForMonth(month, year: year)
    }
    
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.showMonthlyEntriesController.sortedTagsByPercentageFromSections(tags, sections: sections)
    }
    
}
