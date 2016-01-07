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
    // По умолчанию Alamofire запускает response на main потоке
    // поэтому создадим свой последовательный поток
    private let queue = dispatch_queue_create(
        "TaskBerserk.Network.Queue",
        DISPATCH_QUEUE_SERIAL)
    
    func requestJSON(url: String,
        parameters: [String: AnyObject]? = nil,
        headers: [String: String]? = nil) -> Observable<AnyObject> {
            
        return Observable.create { observer -> Disposable in
            let serializer = Alamofire.Request.JSONResponseSerializer()
            let request = Alamofire.request(.GET, url, parameters: parameters, headers: headers)
                .response(queue: self.queue, responseSerializer: serializer) { response in
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
