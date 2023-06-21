//
//  CustomAlertViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/09.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var alertBackgroundView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var alertActionButtonStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    init() {
        super.init(nibName: "CustomAlertViewController", bundle: Bundle(for: CustomAlertViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertBackgroundView.setCorderRadius(cornerRadius: 10)
        setAlertActionButtonUI()
    }

    func setAlertActionButtonUI() {
        let radius = alertActionButtonStackView.frame.height / 2
        cancelButton.setCorderRadius(cornerRadius: radius)
        doneButton.setCorderRadius(cornerRadius: radius)
    }
}
