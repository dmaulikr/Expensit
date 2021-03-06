//
//  BSShowDailyEntriesPresenter.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation


class BSShowDailyEntriesPresenter : BSAbstractShowEntriesPresenter, BSDailyExpensesSummaryPresenterEventsProtocol {

    var visibleSection : String = ""
        

    
    // MARK: BSDailyExpensesSummaryPresenterEventsProtocol
    
    /// Transforms the CoreData query results into view-models adapted for a Daily summary
    ///
    /// - Parameter data: CoreData query results
    /// - Returns: Array of view-models
    override func displayDataFromEntriesForSummary(_ data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {        
        var sections = [BSDisplaySectionData]()
        
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            let monthNumber = coreDatasectionInfo.name.components(separatedBy: "/")[0]
            let numberOfDayInMonths = DateTimeHelper.numberOfDays(inMonth: monthNumber).length
            for i in 0 ..< numberOfDayInMonths {
                
                let dayData = BSDisplayEntry(title: "\(i+1)" , value: "", signOfAmount: .zero)
                entries.append(dayData)
            }
            
            for entryDic in (coreDatasectionInfo.objects)!
            {
                let value = (entryDic as AnyObject).value(forKey: "dailySum") as! NSNumber
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
                let day = (entryDic as AnyObject).value(forKey: "day") as! NSNumber
                let dayString = "\(day)"
                let dailySumString = BSCurrencyHelper.amountFormatter().string(from: value)!
                
                let entryData = BSDisplayEntry(title: dayString as String , value: dailySumString as String, signOfAmount: sign)
                entries[day.intValue - 1] = entryData
            }
            
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }
    
    
    /// User-readble representation of the title of a section.
    ///
    /// - Parameters:
    ///   - indexPath: Index.row represents the day of the month.
    ///   - sectionTitle: String formated date: "<month>/<year>"
    /// - Returns: User-readble representation of the title of a section.
    /// - Important: TODO: Need to encapsulate. This string needs to match the one created at BSShowAllEntriesPresenter.
    func sectionName(forSelected indexPath : IndexPath, sectionTitle: String) -> String {
        let month = sectionTitle.components(separatedBy: "/")[0]
        let year = sectionTitle.components(separatedBy: "/")[1]
        return "\((indexPath as NSIndexPath).row + 1) \(DateTimeHelper.monthName(forMonthNumber: NSDecimalNumber(string: month))!) \(year)"
    }

}
