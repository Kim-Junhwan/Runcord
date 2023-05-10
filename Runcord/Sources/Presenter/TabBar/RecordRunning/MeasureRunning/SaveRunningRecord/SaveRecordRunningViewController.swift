//
//  SaveRecordRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/08.
//

import UIKit

class SaveRecordRunningViewController: UIViewController, Alertable {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var runningRecordMapImageView: CustomRouteMapImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSaveButton()
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
