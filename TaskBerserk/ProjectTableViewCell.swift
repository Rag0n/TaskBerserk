//
//  ProjectTableViewCell.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit

final class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    
    var viewModel: ProjectTableViewCellModeling? {
        didSet {
            projectNameLabel.text = viewModel?.projectName
            taskCount.text = viewModel?.taskCount
        }
    }
}
