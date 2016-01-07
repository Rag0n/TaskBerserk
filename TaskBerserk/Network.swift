//
//  Network.swift
//  TaskBerserk
//
//  Created by Александр on 04.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import RxSwift
import Alamofire

// Инкапсуляруем Alamofire
final class Network: Networking {
    let alamofireManager: Alamofire.Manager
    
    // По умолчанию Alamofire запускает response на main потоке
    // поэтому создадим свой background поток
    private let queue = dispatch_queue_create(
        "TaskBerserk.Network.Queue",
        DISPATCH_QUEUE_SERIAL)
    
    init(alamofireManager: Alamofire.Manager? = nil) {
        if let alamofireManager = alamofireManager {
            self.alamofireManager = alamofireManager
        } else {
            self.alamofireManager = Alamofire.Manager.sharedInstance
        }
        
//        self.alamofireManager.session.configuration.HTTPAdditionalHeaders = ["Authorization": "ApiKey botvafun:09fcdd34040dc44dd47e08ef3fecb2ca8a97c375"]
    }
    
    func requestJSON(url: String, parameters: [String: AnyObject]?) -> Observable<AnyObject> {
        let headers = [
            "Authorization": "ApiKey \(Intheam.Config.apiKey)"
        ]
        return Observable.create { observer -> Disposable in
            let serializer = Alamofire.Request.JSONResponseSerializer()
            let request = self.alamofireManager.request(.GET, url, parameters: parameters, headers: headers)
                .response(queue: self.queue, responseSerializer: serializer) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case .Success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .Failure(let error):
                        observer.onError(NetworkError(error: error))
                    }
            }
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
}
