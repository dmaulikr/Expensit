//

//  AbstractShowEntriesController.swift
//  Expenses
//
//  Created by Borja Arias Drake on 21/05/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import Foundation
import UIKit


/// This class contains template code for subclasses to specialize.
class BSAbstractShowEntriesController : NSObject, BSAbstractShowEntriesControllerProtocol {
 
    var coreDataStackHelper : CoreDataStackHelper
    var coreDataController : BSCoreDataController
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    
    // MARK: Itinializers
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - coreDataStackHelper: helper
    ///   - coreDataController: controller
    required init(coreDataStackHelper : CoreDataStackHelper, coreDataController : BSCoreDataController)
    {
        self.coreDataStackHelper = coreDataStackHelper
        self.coreDataController = coreDataController
        super.init()
    }
    
    
    
    // MARK: BSAbstractShowEntriesControllerProtocol
    
    func filter(by category : Tag)
    {
        let request = self.fetchedResultsController()!.fetchRequest
        self.coreDataController.modifyfetchRequest(request, toFilterByCategory:category)
    }
    
    func entriesForSummary() -> NSDictionary
    {
        let (entries, sections) = self.performFetch()
        
        return NSDictionary(objects: [entries!, sections!], forKeys: ["entries" as NSCopying, "sections" as NSCopying])
    }
    
    func image(for category :Tag?) -> UIImage?
    {
        return self.coreDataController.image(forCategory: category)
    }

    // MARK: Fetch controller
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>?
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
    
    public func fetchedObjects() -> [AnyObject] {
        return (self.fetchedResultsController()?.fetchedObjects)!
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
    
    func sectionNameKeyPath() -> String? {
        return nil
    }

    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest()
    }
}
