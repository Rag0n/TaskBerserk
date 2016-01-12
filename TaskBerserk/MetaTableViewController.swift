//
//  MetaTableViewController.swift
//  TaskBerserk
//
//  Created by Александр on 12.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MetaTableViewController: UITableViewController {
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        filterSegmentedControl.rx_controlEvent(.ValueChanged)
            .subscribeNext {
                
            }
    }
    
    private let disposeBag = DisposeBag()
}

private enum MetaFilter: Int {
    case Projects = 0
    case Tags
    case Contexts
}

extension UISegmentedControl {
    private var metaFilter: MetaFilter {
        guard let mf = MetaFilter(rawValue: selectedSegmentIndex) else {
            fatalError("Invalid filter index")
        }
        return mf
    }
}
