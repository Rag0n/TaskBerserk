//
//  ProjectsTableViewController.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxSwift

final class ProjectsTableViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    private var cells: [ProjectTableViewCellModeling]?
    
    private struct Constants {
        static let projectCellIdentifier = "ProjectTableViewCell"
        static let tasksTableViewSegueIdentifier = "ShowTasks"
    }
    
    var viewModel: ProjectsTableViewModeling? {
        didSet {
            viewModel?.cellModels.bindNext { cellModels in
                self.cells = cellModels
                self.tableView.reloadData()
            }.addDisposableTo(disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updateTasks()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel?.updateTasks()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.tasksTableViewSegueIdentifier {
            guard let vc = segue.destinationViewController.contentViewController as? TasksTableViewController else {
                fatalError("Wrong view controller")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("Impossible to show detail without selected object")
            }
            vc.viewModel = viewModel?.viewModelForIndexPath(indexPath)
        }
    }
}

// MARK: UITableViewDataSource
extension ProjectsTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.projectCellIdentifier, forIndexPath: indexPath) as! ProjectTableViewCell
        
        if let cells = cells {
            cell.viewModel = cells[indexPath.row]
        } else {
            cell.viewModel = nil
        }
        
        return cell
    }
}
