//
//  UIViewController+extensions.swift
//  TaskBerserk
//
//  Created by Александр on 08.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // returns required vc even it's inside navigation controller
    var contentViewController: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.topViewController!
        } else {
            return self
        }
    }
}
