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
    
    
    override func displayDataFromEntriesForSummary(data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        var sections = [BSDisplaySectionData]()
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            for entryDic in (coreDatasectionInfo.objects)!
            {
                let value = entryDic.valueForKey("yearlySum") as! NSNumber
                let r : NSComparisonResult = value.compare(0)
                var sign : BSNumberSignType
                
                switch r
                {
                    case NSComparisonResult.OrderedAscending:
                        sign = .Negative
                    case NSComparisonResult.OrderedDescending:
                        sign = .Positive
                    case NSComparisonResult.OrderedSame:
                        sign = .Zero
                }
                let year = entryDic.valueForKey("year") as! NSNumber
                let yearString = NSString(format:"\(year)")
                let yearlySumString = NSString(format:"\(value)")
                
                let entryData = BSDisplayEntry(title: yearString as String , value: yearlySumString as String, signOfAmount: sign)
                entries.append(entryData)
            }
            
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }

    
}