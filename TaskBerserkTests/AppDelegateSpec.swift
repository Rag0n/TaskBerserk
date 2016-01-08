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
                expect(container.resolve(TaskGrabbing.self)).notTo(beNil())
                
                // ViewModels
                expect(container.resolve(ProjectsTableViewModeling.self)).notTo(beNil())
            }
            
            it("injects view models to views") {
                let bundle = NSBundle.mainBundle()
                let storyboard = SwinjectStoryboard.create(name: "Main",
                    bundle: bundle,
                    container: container)
                
                let taskTableViewController = storyboard.instantiateViewControllerWithIdentifier("ProjectsTableViewController") as? ProjectsTableViewController
                
                expect(taskTableViewController).notTo(beNil())
            }
        }
    }
}
