//
//  TaskChangeProjectViewController.swift
//  TaskBerserk
//
//  Created by Александр on 18.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TaskChangeProjectViewController: UITableViewController {
    var viewModel: TaskChangeProjectViewModeling!
    @IBOutlet weak var addButton: UIBarButtonItem!
}


// MARK: TableViewDelegate
extension TaskChangeProjectViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let oldProjectIndexPath = viewModel.currentProjectIndexPath
        viewModel.changeCurrentProject(indexPath)
        let newCellViewModel = viewModel.viewModelForIndexPath(indexPath)
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! TaskChangeMetaTableViewCell
        cell.viewModel = newCellViewModel
        // it can be used to improve performance, but we somehow have to toggle old meta object
        tableView.reloadRowsAtIndexPaths([oldProjectIndexPath, indexPath], withRowAnimation: .Automatic)
    }
}

// MARK: UITableViewDataSource
extension TaskChangeProjectViewController {
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(
            viewModel.cellIdentifier, forIndexPath: indexPath) as! TaskChangeMetaTableViewCell
        
        cell.viewModel = viewModel.viewModelForIndexPath(indexPath)
        
        return cell
    }
}
