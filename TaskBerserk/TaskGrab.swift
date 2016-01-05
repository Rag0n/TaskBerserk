//
//  TaskGrab.swift
//  TaskBerserk
//
//  Created by Александр on 05.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation
import RxSwift
import Himotoki

class TaskGrab: TaskGrabbing {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }

    // receives all pending tasks(encapsulate into ResponseEntity)
    func grabTasks() -> Observable<ResponseEntity> {
        let url = Intheam.apiURL + "task/"
        let parametres = Intheam.requestParameters
        return network.requestJSON(url, parameters: parametres)
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