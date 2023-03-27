//
//  MyRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/16.
//

import UIKit

class MyRunningViewController: UIViewController {
    
    //MARK: - UI Properties
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .lightGray
        collectionView.register(UINib(nibName: "MyRunningCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyRunningCollectionViewCell.identifier)
        navigationItem.title = "나의 크루 러닝"
    }
    
    func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension MyRunningViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRunningCollectionViewCell.identifier, for: indexPath) as? MyRunningCollectionViewCell else { return MyRunningCollectionViewCell() }

        return cell
    }
    
}

extension MyRunningViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).width
        let height = 172.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15.0)
    }
}
