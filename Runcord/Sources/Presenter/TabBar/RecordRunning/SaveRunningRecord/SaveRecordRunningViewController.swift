//
//  SaveRecordRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/08.
//

import UIKit
import CoreLocation

class SaveRecordRunningViewController: UIViewController, Alertable {
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var runningRecordMapImageView: CustomRouteMapImageView!
    
    // MARK: - Running Start Date Label
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    // MARK: - Running State Label
    @IBOutlet weak var runningHourLabel: UILabel!
    @IBOutlet weak var runningMinuteLabel: UILabel!
    
    // MARK: - Goal Label
    
    @IBOutlet weak var runningDistanceGoalLabel: UILabel!
    @IBOutlet weak var runningTimeGoalHourLabel: UILabel!
    @IBOutlet weak var runningTimeGoalMinuteLabel: UILabel!
    
    let runningRecord: RunningRecord
    let runningRecordRepository: RunningRecordRepository
    
    init(runningRecord: RunningRecord, runningRecordRepository: RunningRecordRepository) {
        self.runningRecord = runningRecord
        self.runningRecordRepository = runningRecordRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSaveButton()
        runningRecordMapImageView.setRouteImage(route: runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
        setDateLabel()
        setRunningTimeLabel()
        setRunningDistanceLabel()
        setGoalLabel()
    }
    
    private func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
    }
    
    private func setDateLabel() {
        let runningDate = runningRecord.date
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day, .hour, .minute], from: runningDate)
        yearLabel.text = String(describing: components.year!)
        monthLabel.text = String(describing: components.month!)
        dayLabel.text = String(describing: components.day!)
        
        hourLabel.text = String(describing: components.hour!)
        minuteLabel.text = String(describing: components.minute!)
    }
    
    private func setRunningTimeLabel() {
        let runningTime = runningRecord.runningTime
        runningHourLabel.text = String(format: "%02d", runningTime / 3600)
        runningMinuteLabel.text = String(format: "%02d", (runningTime % 3600) / 60)
    }
    
    private func setRunningDistanceLabel() {
        let runningDistance = runningRecord.runningDistance
        runningDistanceLabel.text = String(format: "%.2f", runningDistance)
    }
    
    private func setGoalLabel() {
        let goalTime = runningRecord.goalTime
        let goalDistance = runningRecord.goalDistance
        
        runningDistanceGoalLabel.text = String(format: "%.2f", goalDistance)
        runningTimeGoalHourLabel.text = String(format: "%02d", goalTime / 3600)
        runningTimeGoalMinuteLabel.text = String(format: "%02d", (goalTime % 3600) / 60)
    }
    
    // MARK: - Action
    @IBAction func tapCloseButton(_ sender: Any) {
        showAlert(message: "해당 러닝기록이 저장되지 않습니다.", defaultActionTitle: "확인", cancelActionTitle: "취소") { _ in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        runningRecordRepository.saveRunningRecord(runningRecord: runningRecord)
    }
     
}
