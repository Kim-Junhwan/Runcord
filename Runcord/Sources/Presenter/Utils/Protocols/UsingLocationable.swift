//
//  TabStartButton.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/03/30.
//

import UIKit

protocol UsingLocationable: Alertable {
    var locationRepository: LocationRepository { get }
}

extension UsingLocationable where Self: UIViewController {
    func excute() {
        if !locationRepository.checkLocationAuthorization() {
            showAlert(title: "권한 요청", message: "러닝을 시작하려면 현재 위치를 알아야 합니다.", defaultActionTitle: "설정", cancelActionTitle: "취소") { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
