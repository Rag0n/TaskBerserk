//
//  Networking.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift
import Alamofire

protocol Networking {
    func requestJSON(url: String, parameters: [String: AnyObject]?, headers: [String: String]?) -> Observable<AnyObject>
}
