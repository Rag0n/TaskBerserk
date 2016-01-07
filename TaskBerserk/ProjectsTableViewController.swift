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
    }
    
    var viewModel: ProjectsTableViewModeling? {
        didSet {
            viewModel?.cellModels.bindNext { cellModels in
                self.cells = cellModels
                self.tableView.reloadData()
            }.addDisposableTo(disposeBag)
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