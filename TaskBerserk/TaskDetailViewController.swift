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

class TaskDetailViewController: UITableViewController {
    
    var viewModel: TaskDetailViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        
        deleteButton.rx_tap
            .subscribeNext(viewModel.deleteTask)
            .addDisposableTo(disposeBag)
        
        cancelButton.rx_tap
            .subscribeNext { self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    
    @IBOutlet weak var priorityNoneButton: UIButton!
    @IBOutlet weak var priorityLowButton: UIButton!
    @IBOutlet weak var priorityMediumButton: UIButton!
    @IBOutlet weak var priorityHighButton: UIButton!
    @IBOutlet weak var addTagButton: UIButton!
    
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Private
    
    private let disposeBag = DisposeBag()
    
    private func bindToViewModel() {
        viewModel.name
            .bindTo(nameTextField.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.priority
            .bindTo(projectTextField.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.urgency
            .bindTo(urgencyLabel.rx_text)
            .addDisposableTo(disposeBag)
                
        viewModel.status
            .bindTo(statusLabel.rx_text)
            .addDisposableTo(disposeBag)
                
        viewModel.tagsText
            .bindTo(tagsLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
}
