//
//  DetailRunninRecordViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/21.
//

import UIKit

class DetailRunninRecordViewController: DetailRunningRecordBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        detailRunningRecordView.dismissButton.tintColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
}
