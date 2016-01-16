//
//  TaskChangeMetaTableViewCell.swift
//  TaskBerserk
//
//  Created by Александр on 16.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit

final class TaskChangeMetaTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: TaskChangeMetaViewCellModeling! {
        didSet {
            nameLabel.text = viewModel.name
            self.accessoryType = viewModel.accessoryType ? .Checkmark : .None
        }
    }
}
