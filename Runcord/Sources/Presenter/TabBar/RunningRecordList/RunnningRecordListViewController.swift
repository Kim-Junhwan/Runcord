//
//  RunnningRecordListViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit
import RxCocoa
import RxSwift

class RunnningRecordListViewController: UIViewController {
    
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: RunningRecordTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RunningRecordTableViewCell.identifier)
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let viewModel: RunningRecordListViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: RunningRecordListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "러닝기록"
        view.backgroundColor = .systemBackground
        setTableViewConstraint()
        viewModel.fetchRunningRecordList()
        bindRunningList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func bindRunningList() {
        viewModel.runningRecordListDriver.drive(tableView.rx.items) { table, row, data in
            guard let cell = table.dequeueReusableCell(withIdentifier: RunningRecordTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? RunningRecordTableViewCell else { return RunningRecordTableViewCell() }
            cell.setData(runningRecord: data)
            self.tableView.refreshControl?.endRefreshing()
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RunningRecord.self).subscribe(with: self) { owner, runningRecord in
            owner.viewModel.showDetailRunningRecord(runningRecord: runningRecord)
        }.disposed(by: disposeBag)
    }
    
    private func setTableViewConstraint() {
        view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateRunningRecordList), for: .valueChanged)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func updateRunningRecordList() {
        viewModel.fetchRunningRecordList()
    }

}
