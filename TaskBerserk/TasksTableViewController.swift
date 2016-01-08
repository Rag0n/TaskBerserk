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
    
    var viewModel: TasksTableViewModeling? {
        didSet {
            viewModel?.cellModels.bindNext { cellModels in
                self.cells = cellModels
                self.tableView.reloadData()
            }.addDisposableTo(disposeBag)
        }
    }
}

// MARK: UITableViewDataSource
extension TasksTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            Constants.taskCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        
        if let cells = cells {
            cell.viewModel = cells[indexPath.row]
        } else {
            cell.viewModel = nil
        }
        
        return cell
    }
}