//
//  TaskDetailViewController.swift
//  TaskBerserk
//
//  Created by Александр on 11.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskDetailViewController: UIViewController {
    
    var viewModel: TaskDetailViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.desc.bindTo(descriptionLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel?.status.subscribeNext { title in
            self.statusButton.setTitle(title, forState: .Normal)
            }.addDisposableTo(disposeBag)
        
        viewModel?.tagsText.bindTo(tagsLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel?.urgency.bindTo(urgencyLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel?.status.subscribeNext { title in
            self.priorityButton.setTitle(title, forState: .Normal)
        }.addDisposableTo(disposeBag)
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!

    
    // MARK: IBActions
    
    @IBAction func priorityButtonTapped(sender: UIButton) {
    }
    @IBAction func statusButtonTapped(sender: UIButton) {
    }
    @IBAction func addTagButtonTapped(sender: UIButton) {
    }
    
    // MARK: Private
    
    private let disposeBag = DisposeBag()
}
