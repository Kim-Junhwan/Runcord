//
//  SaveRecordRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/08.
//

import UIKit

class SaveRecordRunningViewController: UIViewController {
    
    @IBOutlet weak var runningCommentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCommentTextField()
        setSaveButton()
        setImageCollectionView()
    }
    
    //MARK: - Set UI
    func setCommentTextField() {
        runningCommentTextField.delegate = self
        runningCommentTextField.layer.borderWidth = 2
        runningCommentTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func setSaveButton() {
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
    }
    
    //MARK: - Set CollectionView
    func setImageCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(UINib(nibName: ImageCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.reusableIdentifier)
        imageCollectionView.register(UINib(nibName: AddImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier)
    }
    
    //MARK: - Action
    @IBAction func tapCloseButton(_ sender: Any) {
        showAlert()
    }
}

extension SaveRecordRunningViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        runningCommentTextField.resignFirstResponder()
        return true
    }
}

extension SaveRecordRunningViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.identifier, for: indexPath) as? AddImageCollectionViewCell else { return AddImageCollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reusableIdentifier, for: indexPath) as? ImageCollectionViewCell else { return ImageCollectionViewCell()}
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension SaveRecordRunningViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = imageCollectionView.frame.height
        return CGSize(width: height, height: height)
    }
}
