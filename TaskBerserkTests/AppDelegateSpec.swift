//
//  AppDelegateSpec.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Quick
import Nimble
import Swinject

@testable import TaskBerserk

class AppDelegateSpec: QuickSpec {
    override func spec() {
        var container: Container!
        beforeEach {
            container = AppDelegate().container
        }
        
        describe("Container") {
            it("resolves every service type.") {
                // Models
                expect(container.resolve(Networking.self)).notTo(beNil())
                expect(container.resolve(TaskWebService.self)).notTo(beNil())
                
                // ViewModels
                expect(container.resolve(TasksTableViewModeling.self)).notTo(beNil())
                expect(container.resolve(MetaTableViewModeling.self)).notTo(beNil())
            }
            
            it("injects managedObjectContext to viewModels") {
                let tasksViewModel = container.resolve(TasksTableViewModeling)
                let metaViewModel = container.resolve(MetaTableViewModeling)
                
                expect(tasksViewModel?.managedObjectContext).notTo(beNil())
                expect(metaViewModel?.managedObjectContext).notTo(beNil())
            }
            
            it("injects view models to views") {
                let bundle = NSBundle.mainBundle()
                let storyboard = SwinjectStoryboard.create(name: "Main",
                    bundle: bundle,
                    container: container)
                
                let taskTableViewController = storyboard.instantiateViewControllerWithIdentifier("TasksTableViewController") as? TasksTableViewController
                let metaTableViewController = storyboard.instantiateViewControllerWithIdentifier("MetaTableViewController") as? MetaTableViewController
                
                expect(taskTableViewController).notTo(beNil())
                expect(taskTableViewController?.viewModel).notTo(beNil())
                
                expect(metaTableViewController).notTo(beNil())
                expect(metaTableViewController?.viewModel).notTo(beNil())
            }
        }
    }
}
