//
//  BSYearlySummaryGraphLinePresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 05/06/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


@objc class BSYearlySummaryGraphLinePresenter: NSObject, BSGraphLinePresenterProtocol
{
    var yearlySummaryGraphLineController : BSGraphLineControllerProtocol
    var section: String
    
    
    init(yearlySummaryGraphLineController : BSGraphLineControllerProtocol, section: String)
    {
        self.yearlySummaryGraphLineController = yearlySummaryGraphLineController
        self.section = section
        super.init()
    }
    
    
    func income() -> [AnyObject] {
        let data = self.yearlySummaryGraphLineController.graphSurplusResultsForSection(self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data)
    }

    func expenses() -> [AnyObject] {
        let data = self.yearlySummaryGraphLineController.graphExpensesResultsForSection(self.section)
        return self.dataForGraphFromQueryResults(data)
    }
    
    func abscissaValues() -> [String] {
        let ra = self.yearlySummaryGraphLineController.abscissaValues()
        return ra.map({ (dic) -> String in
            return "\((dic["year"] as! NSNumber))"
        })
    }

    func graphTitle() -> String {
        return self.section
    }

    
    func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        
        var graphData = [NSNumber]()
        let years = self.abscissaValues()
        
        for (i, _) in years.enumerate()
        {
            var monthDictionary : NSDictionary?
            for dic in data  {
                let dataDictionary = dic as! NSDictionary
                let intYear = dataDictionary["year"] as! Int
                let yearstringFromData = "\(intYear)"
                if yearstringFromData == years[i]
                {
                    monthDictionary = (dic as! NSDictionary)
                    break
                }                
            }
            if monthDictionary != nil
            {
                var value = monthDictionary!["yearlySum"] as! NSNumber
                if value.compare(NSNumber(int: 0)) == .OrderedAscending {
                    value = NSNumber(float: -value.floatValue)
                }
                graphData.append(value)
            }
            else
            {
                graphData.append(NSNumber(float: 0))
            }
        }
        
        return graphData
    }
}