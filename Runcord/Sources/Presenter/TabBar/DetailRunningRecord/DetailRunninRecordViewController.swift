//
//  DetailRunninRecordViewController.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/21.
//

import UIKit

class DetailRunninRecordViewController: UIViewController {
    
    let detailRunningRecordView: DetailRunningRecordView = {
       let view = DetailRunningRecordView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let runningRecord: RunningRecord
    
    init(runningRecord: RunningRecord) {
        
        self.runningRecord = runningRecord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setDetailRunningRecordViewLayout()
        detailRunningRecordView.registerRunningRecord(runningRecord: runningRecord)
        detailRunningRecordView.dismissButton.tintColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func setDetailRunningRecordViewLayout() {
        view.addSubview(detailRunningRecordView)
        NSLayoutConstraint.activate([
            detailRunningRecordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailRunningRecordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailRunningRecordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailRunningRecordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
