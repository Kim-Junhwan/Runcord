//
//  CustomMenuBar.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/15.
//

import UIKit

struct MenuItem {
    let title: String
    var isSelect: Bool
}

protocol CustomMenuBarDelegate: AnyObject {
    func didSelect(indexNum: Int)
}

class CustomMenuBar: UIView {
    
    weak var delegate: CustomMenuBarDelegate?
    
    private enum Metric {
        static let currentMarkViewHeight = 2.0
    }
    
    lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 30, height: 30)
        layout.minimumLineSpacing = 0.0
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .zero
        
        return collectionView
    }()
    
    var currentMarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var currentMarkLeading: NSLayoutConstraint = {
        return currentMarkView.leadingAnchor.constraint(equalTo: menuCollectionView.leadingAnchor)
    }()
    
    private var items: [MenuItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setMenuCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        menuCollectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: MenuBarCell.reusableIdentifier)
        addSubview(menuCollectionView)
        addSubview(currentMarkView)
    }
    
    private func setMenuCollectionView() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        NSLayoutConstraint.activate([
            menuCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuCollectionView.topAnchor.constraint(equalTo: topAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.currentMarkViewHeight)
        ])
    }
    
    private func setCurrentMark() {
        NSLayoutConstraint.activate([
            currentMarkView.bottomAnchor.constraint(equalTo: bottomAnchor),
            currentMarkView.heightAnchor.constraint(equalToConstant: Metric.currentMarkViewHeight),
            currentMarkLeading,
            currentMarkView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(items.count))
        ])
    }
    
    func setItems(items: [MenuItem]) {
        self.items = items
        setCurrentMark()
    }
    
}

extension CustomMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuBarCell.reusableIdentifier, for: indexPath) as? MenuBarCell else { return MenuBarCell() }
        cell.itemTitle.text = "\(items[indexPath.row].title)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.isSelected = true
        let selectIndex = CGFloat(indexPath.row)
        let cellWidth = cell.frame.width
        let leadingDistance = selectIndex * cellWidth
        currentMarkLeading.constant = leadingDistance
        delegate?.didSelect(indexNum: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.isSelected = false
    }
    
}

extension CustomMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width/CGFloat(items.count), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
