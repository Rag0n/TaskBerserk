//
//  MetaTableViewModel.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class MetaTableViewModel: MetaTableViewModeling, DataProviderDelegate {
    typealias Object = NameWithCountRepresentable
    typealias ViewModel = MetaTableViewCellModeling
    
    var managedObjectContext: NSManagedObjectContext!
    var updates: Observable<[DataProviderUpdate<MetaTableViewCellModeling>]> {
        return dataProvider.updatesSignal
    }
    
    init(managedObject: NSManagedObjectContext) {
        self.managedObjectContext = managedObject
        setupDataProvider()
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    private func setupDataProvider() {
        let request = Project.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let transformerFunc: (Object) -> ViewModel = { object in
            MetaTableViewCellModel(object: object)
        }
        
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self, transformerFunc: transformerFunc)
    }

    // MARK: Private
    private var dataProvider: FetchedResultsDataProvider<MetaTableViewModel>!
    private let disposeBag = DisposeBag()
}
