//
//  BSShowYearlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSShowYearlyEntriesPresenter : BSAbstractShowEntriesPresenter {
    
    override func abscissaValues() -> [String] {
        let ra = self.showEntriesController.abscissaValues()
        return ra.map({ (dic) -> String in
            return "\((dic["year"] as! NSNumber))"
        })
    }

    override func dataForGraphFromQueryResults(data : [AnyObject])  -> [AnyObject] {
        var graphData = [NSNumber]()
        let years = self.abscissaValues()
        
        for (i, _) in years.enumerate()
        {
            var monthDictionary : NSDictionary?
            for dic in data {
                if let yearValue = dic["year"]
                {
                    if ((yearValue?.isEqual(years[i])) != nil) {
                        monthDictionary = (dic as! NSDictionary)
                        break
                    }
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