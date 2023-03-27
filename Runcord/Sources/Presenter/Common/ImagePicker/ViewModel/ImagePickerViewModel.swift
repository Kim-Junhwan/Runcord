//
//  ImagePickerViewModel.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/03/15.
//

import UIKit
import Photos

class ImagePickerViewModel {
    
    var selectedImages: [UIImage] = []
    private let photosOption: PHFetchOptions = PHFetchOptions()
    var allPhotos : PHFetchResult<PHAsset> = .init()
    
    func viewDidLoad() {
        setPhotosOption()
    }
    
    private func setPhotosOption() {
        photosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: .image, options: photosOption)
        print(allPhotos)
    }
}

