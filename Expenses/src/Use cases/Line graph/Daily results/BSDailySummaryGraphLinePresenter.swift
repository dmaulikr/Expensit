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
        let data = self.dailySummaryGraphLineController.graphSurplusResults(for: self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data) // Get the data from cntroller

    }
    
    func expenses() -> [AnyObject] {
        let data = self.dailySummaryGraphLineController.graphExpensesResults(for: self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        var days = [String]()
        let monthNumber = self.section.components(separatedBy: "/")[0]
        let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
        for i in 0 ..< numberOfDayInMonths {
            days.append("\(i+1)")
        }

        return days
    }
    
    func graphTitle() -> String {
        return self.section
    }
    
    
    /// Helper private
    func dataForGraphFromQueryResults(_ data : [AnyObject])  -> [AnyObject] {
        let monthNumber = self.section.components(separatedBy: "/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDays(inMonth: monthNumber)
        var graphData = Array<NSNumber>(repeating: 0, count: numberOfDaysInMonth.length)
        
        for dic in data {
            let dictionary = dic as! NSDictionary
            let day = dictionary["day"] as! Int
            let dailySum = dictionary["dailySum"] as! NSNumber
            let dailySumAsFloat = dailySum.floatValue
            if dailySumAsFloat > 0 {
                graphData[day] = NSNumber(value: dailySumAsFloat)
            } else {
                graphData[day] = NSNumber(value: -dailySumAsFloat)
            }
        }
        
        return graphData
    }
    
}
