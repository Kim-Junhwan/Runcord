//
//  SaveRecordRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/08.
//

import UIKit
import CoreLocation

class SaveRecordRunningViewController: UIViewController, Alertable {
    
    @IBOutlet weak var detailRunningRecordView: DetailRunningRecordView!
    
    lazy var saveButton: RunningSaveButton = {
        let button = RunningSaveButton()
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        return button
    }()
    
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
        detailRunningRecordView.baseStackView.addArrangedSubview(saveButton)
        detailRunningRecordView.registerRunningRecord(runningRecord: runningRecord)
        detailRunningRecordView.dismissButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        detailRunningRecordView.runningRecordMapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOverlayMapView)))
    }
    
    // MARK: - Action
    @objc func tapCloseButton(_ sender: Any) {
        showAlert(title: "러닝이 저장되지 않습니다.", message: "해당 러닝 기록을 저장하지 않", defaultActionTitle: "확인", cancelActionTitle: "취소") { _ in
            self.dismiss(animated: true)
        }
    }
    
    @objc private func tapSaveButton(_ sender: Any) {
        do {
            try runningRecordRepository.saveRunningRecord(runningRecord: runningRecord)
            self.dismiss(animated: true)
        } catch {
            showAlert(message: "저장 오류 발생. 다시 시도해주십시오. \(error)", defaultActionTitle: "확인", cancelActionTitle: "취소")
        }
    }
    
    @objc private func showOverlayMapView() {
        let overlayMapVC = OverlayMapViewController(runningRecord: runningRecord)
        overlayMapVC.modalPresentationStyle = .fullScreen
        present(overlayMapVC, animated: true)
    }
     
}
