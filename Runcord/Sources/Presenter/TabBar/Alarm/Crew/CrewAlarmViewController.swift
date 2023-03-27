//
//  CrewAlarmViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/16.
//

import UIKit

class CrewAlarmViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UINib(nibName: "CrewAlarmTableViewCell", bundle: nil), forCellReuseIdentifier: CrewAlarmTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CrewAlarmTableViewCell.identifier, for: indexPath) as? CrewAlarmTableViewCell else { return CrewAlarmTableViewCell() }
        cell.alarmTitleLabel.text = "23년 2월 정기러닝닝닝닝닝닝닝닝닝닝닝닝닝닝닝닝닝닝"
        cell.alarmTypeLabel.text = "새로운 전체 공지가 있습니다"
        cell.dateLabel.text = "2023.02.11"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110)
    }
}
