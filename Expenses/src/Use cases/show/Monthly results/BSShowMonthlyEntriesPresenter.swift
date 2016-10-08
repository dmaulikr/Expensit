//
//  BSShowMonthlyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowMonthlyEntriesPresenter : BSAbstractShowEntriesPresenter
{    
    /// From BSAbstractShowEntriesPresenter
    
    override func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {
        var sections = [BSDisplaySectionData]()
        
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            for i in 0 ..< 12 {
                
                let monthData = BSDisplayEntry(title: DateTimeHelper.monthName(forMonthNumber: NSNumber(value: i+1)).uppercased() , value: "", signOfAmount: .zero)
                entries.append(monthData)
            }

            for entryDic in (coreDatasectionInfo.objects)!
            {
                let value = (entryDic as AnyObject).value(forKey: "monthlySum") as! NSNumber
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
                let month = (entryDic as AnyObject).value(forKey: "month") as! NSNumber
                let monthString = DateTimeHelper.monthName(forMonthNumber: month).uppercased()
                let monthlySumString = BSCurrencyHelper.amountFormatter().string(from: value)!
                
                let entryData = BSDisplayEntry(title: monthString as String , value: monthlySumString as String, signOfAmount: sign)
                entries[month.intValue - 1] = entryData
            }
            
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }

}
