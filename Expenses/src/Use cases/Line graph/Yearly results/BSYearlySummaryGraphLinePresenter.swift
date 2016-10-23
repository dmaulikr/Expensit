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
        let data = self.yearlySummaryGraphLineController.graphSurplusResults(for: self.section) // Get the data from cntroller
        return self.dataForGraphFromQueryResults(data)
    }

    func expenses() -> [AnyObject] {
        let data = self.yearlySummaryGraphLineController.graphExpensesResults(for: self.section)
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

    
    func dataForGraphFromQueryResults(_ data : [AnyObject])  -> [AnyObject] {
        
        var graphData = [NSNumber]()
        let years = self.abscissaValues()
        
        for (i, _) in years.enumerated()
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
                let value = monthDictionary!["yearlySum"] as! NSNumber
                graphData.append(value)
            }
            else
            {
                graphData.append(NSNumber(value: 0))
            }
        }
        
        return graphData
    }
}
