//
//  ImagePickerViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/11.
//

import UIKit
import Photos

class ImagePickerViewController: UIViewController {

    //MARK: - ImageCollectionView UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Authorization UI
    @IBOutlet weak var authorizationView: UIView!
    @IBOutlet weak var authorizationButton: UIButton!
    
    //MARK: - Photo Properties
    private let imageManager: PHCachingImageManager = .init()
    
    private var thumnailSize: CGSize?
    
    let viewModel: ImagePickerViewModel = ImagePickerViewModel()
    let cellSpacing = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationStatusSetView()
    }
    func calculateThumnailSize() {
        guard let scale = view.window?.windowScene?.screen.scale else { return }
        guard let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellSize = collectionViewFlowLayout.itemSize
        thumnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    func authorizationStatusSetView() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.setCollectionView()
                    self.showCollectionView()
                    self.viewModel.viewDidLoad()
                }
            case .limited, .notDetermined, .restricted, .denied:
                DispatchQueue.main.async {
                    self.showAuthorizationView()
                }
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func showCollectionView() {
        self.collectionView.isHidden = false
        self.authorizationView.isHidden = true
    }
    
    private func showAuthorizationView() {
        self.collectionView.isHidden = true
        self.authorizationView.isHidden = false
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: ImagePickerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: CameraCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CameraCollectionViewCell.identifier)
    }
    
    private func setAuthorizationView() {
        authorizationButton.clipsToBounds = true
        authorizationButton.layer.cornerRadius = 5
    }
    
    @IBAction func tapAuthorizationButton(_ sender: Any) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCollectionViewCell.identifier, for: indexPath) as? CameraCollectionViewCell else { return CameraCollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.identifier, for: indexPath) as? ImagePickerCollectionViewCell else { return ImagePickerCollectionViewCell() }
            let asset = viewModel.allPhotos.object(at: indexPath.row-1)
            
            let collectionViewWidth = collectionView.bounds.width
            let width = Double(collectionViewWidth/3) - cellSpacing
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { image, _ in
                cell.imageView.image = image
            }
            cell.isSelected = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isSelected.toggle()
        }
    }
}

extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let width = Double(collectionViewWidth/3) - cellSpacing
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
