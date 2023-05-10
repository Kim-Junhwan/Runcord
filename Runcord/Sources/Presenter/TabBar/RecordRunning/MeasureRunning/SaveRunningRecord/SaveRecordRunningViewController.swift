//
//  SaveRecordRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/08.
//

import UIKit
import CoreLocation

class SaveRecordRunningViewController: UIViewController, Alertable {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var runningRecordMapImageView: CustomRouteMapImageView!
    
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
        setSaveButton()
        runningRecordMapImageView.setRouteImage(route: runningRecord.runningPath.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) })
    }
    
    func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
    }
    
    // MARK: - Action
    @IBAction func tapCloseButton(_ sender: Any) {
        showAlert(message: "해당 러닝기록이 저장되지 않습니다.", defaultActionTitle: "확인", cancelActionTitle: "취소") { _ in
            self.dismiss(animated: true)
        }
    }
    
}
