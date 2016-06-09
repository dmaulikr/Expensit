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
    var showDailyEntriesController : BSShowDailyEntriesControllerProtocol
    
    /// Initialization
    init(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol, showDailyEntriesController : BSShowDailyEntriesControllerProtocol)
    {
        self.showDailyEntriesController = showDailyEntriesController
        super.init(showEntriesUserInterface: showEntriesUserInterface, showEntriesController: showDailyEntriesController)
    }
    
    override init!(showEntriesUserInterface: BSAbstractExpensesSummaryUserInterfaceProtocol,
                   showEntriesController : BSAbstractShowEntriesControllerProtocol) {
        
        return nil // Not upported to enforce the use of the specialised init method
    }
    
    func arrayDayNumbersInMonthFromVisibleSection(section: String) -> [String]
    {
        let monthNumber = section.componentsSeparatedByString("/")[0]
        let numberOfDaysInMonth = DateTimeHelper.numberOfDaysInMonth(monthNumber)
        let dayNumbers : [Int] = Array(1...numberOfDaysInMonth.length)
        
        return dayNumbers.map { "\($0)" }
    }
    
    /// BSDailyExpensesSummaryPresenterEventsProtocol
    func expensesByCategoryForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.showDailyEntriesController.expensesByCategoryForMonth(month, year: year)
    }
    
    func sortedTagsByPercentageFromSections(tags: [Tag], sections : [AnyObject]?) -> [AnyObject]? {
        return self.showDailyEntriesController.sortedTagsByPercentageFromSections(tags, sections: sections)
    }
    
    func categoriesForMonth(month: NSNumber?, year : Int) -> [AnyObject]? {
        return self.showDailyEntriesController.categoriesForMonth(month, year: year)
    }

    override func displayDataFromEntriesForSummary(data : [NSFetchedResultsSectionInfo]) -> [BSDisplaySectionData]
    {        
        var sections = [BSDisplaySectionData]()
        
        for coreDatasectionInfo in data
        {
            var entries = [BSDisplayEntry]()
            let monthNumber = coreDatasectionInfo.name.componentsSeparatedByString("/")[0]
            let numberOfDayInMonths = DateTimeHelper.numberOfDaysInMonth(monthNumber).length
            for var i=0; i<numberOfDayInMonths; i += 1 {
                
                let dayData = BSDisplayEntry(title: "\(i+1)" , value: "", signOfAmount: .Zero)
                entries.append(dayData)
            }
            
            for entryDic in (coreDatasectionInfo.objects)!
            {
                let value = entryDic.valueForKey("dailySum") as! NSNumber
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
                let day = entryDic.valueForKey("day") as! NSNumber
                let dayString = "\(day)"
                let dailySumString = BSCurrencyHelper.amountFormatter().stringFromNumber(value)!
                
                let entryData = BSDisplayEntry(title: dayString as String , value: dailySumString as String, signOfAmount: sign)
                entries[day.integerValue - 1] = entryData
            }
            
            let sectionData = BSDisplaySectionData(title: coreDatasectionInfo.name, entries: entries)
            sections.append(sectionData)
        }
        
        return sections
    }
    
    
    func sectionNameForSelectedIndexPath(indexPath : NSIndexPath, sectionTitle: String) -> String {
        let month = sectionTitle.componentsSeparatedByString("/")[0]
        let year = sectionTitle.componentsSeparatedByString("/")[1]
        return "\(year)/\(month)/\(indexPath.row + 1)"
    }

}
