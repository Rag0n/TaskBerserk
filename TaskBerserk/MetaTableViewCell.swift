//
//  MetaTableViewCell.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit

class MetaTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var viewModel: MetaTableViewCellModeling? {
        didSet {
            nameLabel.text = viewModel?.name
            countLabel.text = viewModel?.count
        }
    }
}
