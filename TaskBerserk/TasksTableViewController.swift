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
    
    var viewModel: TasksTableViewModeling! {
        didSet {
            viewModel.updates
                .subscribeNext { self.processUpdates($0) }
                .addDisposableTo(disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        configureButtonActions()
    }
    
    
    // MARK: IB
    @IBOutlet weak var fetchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    
    private struct Constants {
        static let taskCellIdentifier = "TaskTableViewCell"
        static let taskDetailSegueIdentifier = "ShowTaskDetail"
    }
    
    private func configureButtonActions() {
        fetchButton.rx_tap
            .subscribeNext {
                self.viewModel.fetchTasks()
            }
            .addDisposableTo(disposeBag)
        
        addButton.rx_tap
            .subscribeNext { [weak self] in
                let ac = UIAlertController(title: "New task", message: nil, preferredStyle: .Alert)
                
                ac.addTextFieldWithConfigurationHandler { textField in
                    textField.placeholder = "Enter task name here"
                }
                let addTaskAction = UIAlertAction(title: "Add task", style: .Default) { _ in
                    let textField = ac.textFields![0]
                    self?.viewModel.addNewTask(textField.text)
                }
                
                ac.addAction(addTaskAction)
                ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                self?.presentViewController(ac, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
}

// MARK: Navigation
extension TasksTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.taskDetailSegueIdentifier {
            guard let vc = segue.destinationViewController.contentViewController as? TaskDetailViewController else {
                fatalError("Wrong view controller")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("Impossible to show detail without selected object")
            }
            vc.viewModel = viewModel.detailViewModelForIndexPath(indexPath)
        }
    }
}

// MARK: UITableViewDataSource
extension TasksTableViewController {
    
    func processUpdates(updates: [DataProviderUpdate<TaskTableViewCellModeling>]?) {
        guard let updates = updates else { return }
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
