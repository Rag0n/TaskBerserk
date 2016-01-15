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
    let container = Container() { container in
        let managedObjectContext = createManagedContext(.MainQueueConcurrencyType)
        let backgroundManagedObjectContext = createManagedContext(.PrivateQueueConcurrencyType)
//        AppDelegate.registerUpdateNotification(managedObjectContext)
        
        // Models
        container.register(Networking.self) { _ in Network() }
        container.register(TaskWebService.self) { r in
            IntheamWebService(network: r.resolve(Networking.self)!)
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
    
    // updates main context after background context finished savings
//    private static func registerUpdateNotification(moc: NSManagedObjectContext) {
//        NSNotificationCenter.defaultCenter()
//            .addObserverForName("NSManagedObjectContextDidSaveNotification", object: nil, queue: nil) { notification in
//                guard let notificationManagedObjectContext = notification.object as? NSManagedObjectContext else {
//                    fatalError("Wrong notification object")
//                }
//                if notificationManagedObjectContext != moc {
//                    moc.performBlock {
//                        moc.mergeChangesFromContextDidSaveNotification(notification)
//                    }
//                }
//            }
//    }
}
