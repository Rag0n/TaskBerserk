//
//  TaskChangeMetaTableViewController.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TaskChangeMetaTableViewController: UITableViewController {
    var viewModel: TaskChangeMetaViewModeling!
    
}

// MARK: UITableViewDataSource
extension TaskChangeMetaTableViewController {
    
    func processUpdates(updates: [DataProviderUpdate<TaskChangeMetaViewCellModeling>]?) {
        guard let updates = updates else { return }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let cellViewModel):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? TaskChangeMetaTableViewCell else { break }
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Запрашивать cellIdentifier у модели
        let cell = tableView.dequeueReusableCellWithIdentifier(
            viewModel.cellIdentifier, forIndexPath: indexPath) as! TaskChangeMetaTableViewCell
        
        let cellViewModel = viewModel.viewModelForIndexPath(indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}
