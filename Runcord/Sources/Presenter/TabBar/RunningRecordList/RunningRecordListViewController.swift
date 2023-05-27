//
//  RunnningRecordListViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/13.
//

import UIKit
import RxCocoa
import RxSwift

class RunningRecordListViewController: UIViewController, Alertable {
    
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
        tableView.delegate = self
        viewModel.runningRecordListDriver.drive(tableView.rx.items) { table, row, data in
            guard let cell = table.dequeueReusableCell(withIdentifier: RunningRecordTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? RunningRecordTableViewCell else { return RunningRecordTableViewCell() }
            cell.setData(runningRecord: data)
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
        viewModel.fetchRunningRecordList {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

}

extension RunningRecordListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let deleteAction =
            UIAction(title: NSLocalizedString("기록 삭제", comment: ""),
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive) { _ in
                self.showAlert(message: "러닝 기록을 삭제합니다.", defaultActionTitle: "삭제", cancelActionTitle: "취소") { _ in
                    self.viewModel.deleteRunningRecord(indexPath: indexPath)
                    self.viewModel.fetchRunningRecordList()
                }
                
            }
            return UIMenu(title: "", children: [deleteAction])
        })
    }
}
