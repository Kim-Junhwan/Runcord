//
//  Alertable.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(title: String = "", message: String, defaultActionTitle: String, cancelActionTitle: String, defaultActionBlock: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionTitle, style: .default, handler: defaultActionBlock)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
}
