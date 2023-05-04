//
//  ImageAnnotationView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/04.
//

import UIKit
import MapKit

class ImageAnnotationView: MKAnnotationView {
    
    static let identifier = "ImageAnnotationView"
    
    private var annotationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var locationArrowView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        
        return view
    }()
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        setStackViewLayout()
        setImageAnnotationLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackViewLayout() {
        addSubview(annotationStackView)
        NSLayoutConstraint.activate([
            annotationStackView.topAnchor.constraint(equalTo: topAnchor),
            annotationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            annotationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            annotationStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setImageAnnotationLayout() {
        annotationStackView.addArrangedSubview(imageBackgroundView)
        imageBackgroundView.addSubview(imageView)
        annotationStackView.addArrangedSubview(locationArrowView)
        
        NSLayoutConstraint.activate([
            imageBackgroundView.widthAnchor.constraint(equalTo: annotationStackView.widthAnchor),
            imageBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageBackgroundView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageBackgroundView.heightAnchor, multiplier: 0.8)
        ])
    }
}
