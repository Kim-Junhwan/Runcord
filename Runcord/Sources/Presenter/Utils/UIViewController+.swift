//
//  UIViewController+.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/09.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - Keyboard
    func scrollViewKeyboardHiddenSetting(scrollView: UIScrollView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        scrollView.addGestureRecognizer(gesture)
    }
    
    @objc func tapScrollView() {
        self.view.endEditing(true)
    }
    
    //MARK: - Alert
    func showAlert() {
        let customAlterVC = CustomAlertViewController()
        customAlterVC.modalPresentationStyle = .overFullScreen
        present(customAlterVC, animated: true)
    }
}
