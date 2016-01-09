//
//  TasksTableViewController.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TasksTableViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    private var cells: [TaskTableViewCellModeling]?
    
    private struct Constants {
        static let taskCellIdentifier = "TaskTableViewCell"
    }
    
    var viewModel: TasksTableViewModeling! {
        didSet {
//            viewModel?.cellModels.bindNext { cellModels in
//                self.cells = cellModels
//                self.tableView.reloadData()
//            }.addDisposableTo(disposeBag)
            
            viewModel.updates.subscribeNext { update in
                self.processUpdates(update)
            }.addDisposableTo(disposeBag)
        }
    }
    
    func processUpdates(updates: [DataProviderUpdate<Task>]?) {
        guard let updates = updates else { return }
//        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let object):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
                cell.configureForObject(object)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
    }
}

// MARK: UITableViewDataSource
extension TasksTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(
//            Constants.taskCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
//        
//        if let cells = cells {
//            cell.viewModel = cells[indexPath.row]
//        } else {
//            cell.viewModel = nil
//        }
//        
//        return cell
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Запрашивать cellIdentifier у модели
        let cell = tableView.dequeueReusableCellWithIdentifier(
            Constants.taskCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        
        let cellViewModel = viewModel.viewModelForIndexPath(indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}

//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let object = dataProvider.objectAtIndexPath(indexPath)
//    let identifier = delegate.cellIdentifierForObject(object)
//    
//    guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell else {
//        fatalError("Unexpected cell type at \(indexPath)")
//    }
//    cell.configureForObject(object)
//    
//    return cell
//}

// MARK: UITableViewDataSource
//extension TasksTableViewController {
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cells?.count ?? 0
//    }
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(
//            Constants.taskCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
//
//        if let cells = cells {
//            cell.viewModel = cells[indexPath.row]
//        } else {
//            cell.viewModel = nil
//        }
//
//        return cell
//    }
//}
