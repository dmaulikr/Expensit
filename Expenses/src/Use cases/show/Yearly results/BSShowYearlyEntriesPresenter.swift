//
//  BSShowYearlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation

class BSShowYearlyEntriesPresenter : BSAbstractShowEntriesPresenter
{    
    override func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        var sections = [BSDisplaySectionData]()
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            for entryDic in (coreDatasectionInfo.objects)!
            {
                let value = entryDic.value(forKey: "yearlySum") as! NSNumber
                let r : ComparisonResult = value.compare(0)
                var sign : BSNumberSignType
                
                switch r
                {
                    case ComparisonResult.orderedAscending:
                        sign = .negative
                    case ComparisonResult.orderedDescending:
                        sign = .positive
                    case ComparisonResult.orderedSame:
                        sign = .zero
                }
                let year = entryDic.value(forKey: "year") as! NSNumber
                let yearString = NSString(format:"\(year)")
                let yearlySumString = BSCurrencyHelper.amountFormatter().string(from: value)!
                
                let entryData = BSDisplayEntry(title: yearString as String , value: yearlySumString as String, signOfAmount: sign)
                entries.append(entryData)
            }
            
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }
    
}
