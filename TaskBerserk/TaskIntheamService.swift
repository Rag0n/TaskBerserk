//
//  TaskIntheamService.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import Himotoki

class TaskIntheamService: TaskWebService {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }

    // receives all pending tasks(encapsulate into ResponseEntity)
    func fetchAllTask() -> Observable<ResponseEntity> {
        let url = Intheam.apiURL + Intheam.apiURLEnd
        let headers = Intheam.requestHeaders
        
        return network.requestJSON(url, parameters: nil, headers: headers)
            .flatMap { json -> Observable<ResponseEntity> in
                return Observable.create { observer -> Disposable in
                    if let response = (try? decode(json)) as ResponseEntity? {
                        observer.onNext(response)
                        observer.onCompleted()
                    } else {
                        observer.onError(NetworkError.IncorrectDataReturned)
                    }
                    
                    return NopDisposable.instance
                }
            }
    }
}