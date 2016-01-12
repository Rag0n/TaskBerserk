//
//  MetaTableViewController.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MetaTableViewController: UITableViewController {
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    
    var viewModel: MetaTableViewModeling! {
        didSet {
            viewModel.updates
                .subscribeNext { update in
                    self.processUpdates(update)
                }.addDisposableTo(disposeBag)
        }
    }
    
    func processUpdates(updates: [DataProviderUpdate<MetaTableViewCellModeling>]?) {
        // nil if fetchedResultsDataProvider was reconfigured
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let cellViewModel):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? MetaTableViewCell else { break }
                cell.viewModel = cellViewModel
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
    }
    
    
    private let disposeBag = DisposeBag()
    
    private struct Constants {
        static let metaCellIdentifier = "MetaTableViewCell"
    }
}

private enum MetaFilter: Int {
    case Projects = 0
    case Tags
    case Contexts
}

extension UISegmentedControl {
    private var metaFilter: MetaFilter {
        guard let mf = MetaFilter(rawValue: selectedSegmentIndex) else {
            fatalError("Invalid filter index")
        }
        return mf
    }
}

// MARK: UITableViewDataSource
extension MetaTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Запрашивать cellIdentifier у модели
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.metaCellIdentifier,
            forIndexPath: indexPath) as! MetaTableViewCell
        
        let cellViewModel = viewModel.viewModelForIndexPath(indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}
