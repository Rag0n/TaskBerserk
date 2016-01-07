//
//  TaskTableViewCell.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel: TaskTableViewCellModeling? {
        didSet {
            descriptionLabel.text = viewModel?.description
            tagsLabel.text = viewModel?.tagsText
            statusLabel.text = viewModel?.status
        }
    }
}
