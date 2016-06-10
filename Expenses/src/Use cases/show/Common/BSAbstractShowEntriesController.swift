//
//  AbstractShowEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit

class BSAbstractShowEntriesController : NSObject, BSAbstractShowEntriesControllerProtocol {
 
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    private var _fetchedResultsController: NSFetchedResultsController?
    
    /// Initializer
    
    override init()
    {
        let delegate = UIApplication.sharedApplication().delegate as! BSAppDelegate
        self.coreDataStackHelper = delegate.coreDataHelper;
        self.coreDataController = BSCoreDataController(entityName : "Entry", delegate:nil, coreDataHelper:self.coreDataStackHelper)
        
        super.init()
    }
    
    
    
    /// BSAbstractShowEntriesControllerProtocol
    
    func filterByCategory(category : Tag)
    {
        if (_fetchedResultsController != nil)
        {
            let request = _fetchedResultsController!.fetchRequest
            self.coreDataController.modifyfetchRequest(request, toFilterByCategory:category)
        }
    }
    
    func entriesForSummary() -> NSDictionary
    {
        let (entries, sections) = self.performFetch()
        
        return NSDictionary(objects: [entries!, sections!], forKeys: ["entries", "sections"])
    }
    
    func imageForCategoy(category :Tag?) -> UIImage?
    {
        return self.coreDataController.imageForCategory(category)
    }

    func sectionNameKeyPath() -> String? {
        return nil
    }

    // FETCH CONTROLLER
    func fetchedResultsController() -> NSFetchedResultsController?
    {
        
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController!
        }
        
        // Create the request
        let fetchRequest = self.fetchRequest()
        
        // FetchedResultsController
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStackHelper.managedObjectContext, sectionNameKeyPath: self.sectionNameKeyPath(), cacheName: nil)
        
        return _fetchedResultsController
    }
    
    func performFetch() -> ([AnyObject]?, [AnyObject]?)
    {
        do
        {
            try self.fetchedResultsController()?.performFetch()
            return (self.fetchedResultsController()?.fetchedObjects, self.fetchedResultsController()?.sections)
        }
        catch
        {
            print("Unresolved error fetching results.")
            abort();
        }

    }
    
    func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest()
    }
}