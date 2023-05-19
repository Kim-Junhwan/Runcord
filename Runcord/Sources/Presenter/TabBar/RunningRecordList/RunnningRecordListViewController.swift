//
//  RunnningRecordListViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit
import RxCocoa

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
        navigationController?.hidesBarsOnSwipe = true
        viewModel.fetchRunningRecordList()
        bindRunningList()
    }
    
    private func bindRunningList() {
        viewModel.runningRecordListDriver.drive(tableView.rx.items) { table, row, data in
            guard let cell = table.dequeueReusableCell(withIdentifier: RunningRecordTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? RunningRecordTableViewCell else { return RunningRecordTableViewCell() }
            cell.setData(runningRecord: data)
            return cell
        }
    }
    
    private func setTableViewConstraint() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
