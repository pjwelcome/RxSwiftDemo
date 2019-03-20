//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by pjapple on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var viewBinding = ViewBinding ()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBinding.bind(on: self.searchbar)
        viewBinding.bind(view: self.tableview)
    }
}
