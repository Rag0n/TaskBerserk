//
//  TaskChangeTagsViewController.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TaskChangeTagsViewController: UITableViewController {
    var viewModel: TaskChangeTagsViewModeling!
    @IBOutlet weak var addNewButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tableViewShouldUpdates
            .filter { $0 == true }
            .subscribeNext { _ in self.tableView.reloadData() }
            .addDisposableTo(disposeBag)
        
        addNewButton.rx_tap
            .subscribeOn(MainScheduler.instance)
            .subscribeNext { [weak self] in
                self?.showAddNewTagAlert()
            }
            .addDisposableTo(disposeBag)
    }
    
    private func showAddNewTagAlert() {
        let ac = UIAlertController(title: "New Tag", message: nil, preferredStyle: .Alert)
        
        ac.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Enter tag name here"
        }
        let addTaskAction = UIAlertAction(title: "Add tag", style: .Default) { _ in
            let textField = ac.textFields![0]
            self.viewModel.addNewTag(textField.text)
        }
        
        ac.addAction(addTaskAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    private let disposeBag = DisposeBag()
}

// MARK: TableViewDelegate
extension TaskChangeTagsViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.changeCurrentTag(indexPath)
        let newCellViewModel = viewModel.viewModelForIndexPath(indexPath)
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! TaskChangeMetaTableViewCell
        cell.viewModel = newCellViewModel
//        // it can be used to improve performance, but we somehow have to toggle old meta object
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension TaskChangeTagsViewController {
    
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
