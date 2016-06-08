//
//  BSMonthlySummaryGraphLinePresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 08/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

@objc class BSMonthlySummaryGraphLinePresenter: NSObject, BSGraphLinePresenterProtocol {
    
    var monthlySummaryGraphLineController : BSGraphLineControllerProtocol
    var section: String
    
    
    init(monthlySummaryGraphLineController : BSGraphLineControllerProtocol, section: String)
    {
        self.monthlySummaryGraphLineController = monthlySummaryGraphLineController
        self.section = section
        super.init()
    }
    
    
    func income() -> [AnyObject] {
        let data = self.monthlySummaryGraphLineController.graphSurplusResultsForSection(self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data)
    }
    
    func expenses() -> [AnyObject] {
        let data = self.monthlySummaryGraphLineController.graphExpensesResultsForSection(self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }

    
    /// Helper private
    func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        var graphData = Array<NSNumber>(count: 12, repeatedValue: 0)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let month = dictionary["month"] as! Int
            let monthlySum = dictionary["monthlySum"] as! Float
            
            if monthlySum < 0 {
                graphData[month-1] = -monthlySum
            } else {
                graphData[month-1] = monthlySum
            }
        }
        
        return graphData
    }
    
    func graphTitle() -> String {
        return ""
    }
}