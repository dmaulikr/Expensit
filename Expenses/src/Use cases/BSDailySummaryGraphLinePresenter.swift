//
//  BSDailySummaryGraphLinePresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 09/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSDailySummaryGraphLinePresenter: NSObject, BSGraphLinePresenterProtocol {
    
    var dailySummaryGraphLineController : BSGraphLineControllerProtocol
    var section: String
    
    
    init(dailySummaryGraphLineController : BSGraphLineControllerProtocol, section: String)
    {
        self.dailySummaryGraphLineController = dailySummaryGraphLineController
        self.section = section
        super.init()
    }
    
    
    func income() -> [AnyObject] {
        let data = self.dailySummaryGraphLineController.graphSurplusResultsForSection(self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data) // Get the data from cntroller

    }
    
    func expenses() -> [AnyObject] {
        let data = self.dailySummaryGraphLineController.graphExpensesResultsForSection(self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        var days = [String]()
        let monthNumber = self.section.componentsSeparatedByString("/")[0]
        let numberOfDayInMonths = DateTimeHelper.numberOfDaysInMonth(monthNumber).length
        for var i=0; i<numberOfDayInMonths; i += 1 {
            days.append("\(i+1)")
        }

        return days
    }
    
    func graphTitle() -> String {
        return self.section
    }
    
    
    /// Helper private
    func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        let monthNumber = self.section.componentsSeparatedByString("/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDaysInMonth(monthNumber)
        var graphData = Array<NSNumber>(count: numberOfDaysInMonth.length, repeatedValue: 0)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let day = dictionary["day"] as! Int
            let dailySum = dictionary["dailySum"] as! Float
            
            if dailySum > 0 {
                graphData[day] = dailySum
            } else {
                graphData[day] = -dailySum
            }
        }
        
        return graphData
    }
    
}