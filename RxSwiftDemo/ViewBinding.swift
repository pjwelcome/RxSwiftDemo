//
//  ViewBinding.swift
//  RxSwiftDemo
//
//  Created by pjapple on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewBinding {
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    var connectivityHandler = SessionHandler.shared
    
    func bind(on searchbar : UISearchBar) {
        searchbar.rx.text.bind(to: viewModel.query).disposed(by: disposeBag)
        searchbar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                
                self?.viewModel.retrieveStuff()
                self?.connectivityHandler.session.sendMessage(["msg" : "Hello Grads"], replyHandler: nil) { (error) in
                    print("Error sending message: \(error)")
                }
                
                
                
            }).disposed(by: disposeBag)
        
        searchbar.rx.cancelButtonClicked
            .map{ _ in "" }
            .bind(to: viewModel.query)
            .disposed(by: disposeBag)
    }
    
    func bind(view tableView: UITableView) {
        tableView.rx.itemSelected.subscribe(onNext : { indexPath in
            print(indexPath.row)
        }).disposed(by: disposeBag)
        
        viewModel.results.subscribe(  onNext :{ [weak self] result in
            self?.populate(tableView, list: result)
        }).disposed(by: disposeBag)
        
    }
    
    private func populate(_ tableview : UITableView ,list : [String]) {
        let listObserverable = Observable.just(list)
        listObserverable.bind(to: tableview.rx.items) { tableView, row, result in
            let indexPath = IndexPath(row: row, section: 0)
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "\(result) \(arc4random())"
            return cell
            }
            .disposed(by: disposeBag)
    }
    
}
