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
    
    private struct Constants {
        static let taskCellIdentifier = "TaskTableViewCell"
    }
    
    var viewModel: TasksTableViewModeling! {
        didSet {
            viewModel.updates
                .subscribeNext { update in
                    self.processUpdates(update)
                }.addDisposableTo(disposeBag)
        }
    }
    
    func processUpdates(updates: [DataProviderUpdate<TaskTableViewCellModeling>]?) {
        guard let updates = updates else { return }
//        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let cellViewModel):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? TaskTableViewCell else { break }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTaskDetail" {
            guard let vc = segue.destinationViewController.contentViewController as? TaskDetailViewController else {
                fatalError("Wrong view controller")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("Impossible to show detail without selected object")
            }
            vc.viewModel = viewModel.detailViewModelForIndexPath(indexPath)
        }
    }
    
    @IBAction func addNewTask(sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "New task", message: nil, preferredStyle: .Alert)
        
        ac.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Enter task name here"
        }
        let addTaskAction = UIAlertAction(title: "Add task", style: .Default) { _ in
            let textField = ac.textFields![0]
            let newTask = TaskEntity(description: textField.text!, id: NSUUID().UUIDString, projectName: "Default", urgency: 0, status: "pending")
            self.viewModel.addNewTask(newTask)
        }
        
        ac.addAction(addTaskAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(ac, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension TasksTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Запрашивать cellIdentifier у модели
        let cell = tableView.dequeueReusableCellWithIdentifier(
            Constants.taskCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        
        let cellViewModel = viewModel.viewModelForIndexPath(indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}
