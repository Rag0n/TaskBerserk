//
//  AppDelegate.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import UIKit
import Swinject
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let managedObjectContext = createMainContext()
    let container = Container() { container in
        let managedObjectContext = createMainContext()
        
        // Models
        container.register(Networking.self) { _ in Network() }
        container.register(TaskWebService.self) { r in
            TaskGrab(network: r.resolve(Networking.self)!)
        }
        
        // ViewModels
        container.register(TasksTableViewModeling.self) { r in
            let viewModel = TasksTableViewModel(managedObject: managedObjectContext)
            return viewModel
        }
        
        container.register(MetaTableViewModeling.self) { r in
            let viewModel = MetaTableViewModel(managedObject: managedObjectContext)
            return viewModel
        }
        
        // Views
        container.registerForStoryboard(TasksTableViewController.self) { r, c in
            c.viewModel = r.resolve(TasksTableViewModeling.self)!
        }
        
        container.registerForStoryboard(MetaTableViewController.self) { r, c in
            c.viewModel = r.resolve(MetaTableViewModeling.self)!
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        self.window = window
        
        let bundle = NSBundle.mainBundle()
        let storyboard = SwinjectStoryboard.create(name: "Main",
            bundle: bundle,
            container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        return true
    }
}
