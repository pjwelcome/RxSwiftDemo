//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by pjapple on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let query = BehaviorRelay<String?>(value: nil)
    var results : PublishSubject<[String]> = PublishSubject<[String]>()
    
    func retrieveStuff() {
        results.onNext(["Peter","John", "Welcome", "Cocoaheads"])
    }
}
