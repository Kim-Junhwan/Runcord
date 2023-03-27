//
//  MeasureRunningViewController.swift
//  RunningCrew
//
//  Created by JunHwan Kim on 2023/02/21.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class RunningStartViewController: UIViewController {
    
    //MARK: - UI Properties
    
    lazy var mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    lazy var startButtonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 41.0
        
        return  stackView
    }()
    
    lazy var distanceSettingStackView: GoalSettingStackView = {
        let distanceSettingStackView = GoalSettingStackView(goalType: .distance)
        distanceSettingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDistanceLabel))
        distanceSettingStackView.goalSettingLabelStackView.isUserInteractionEnabled = true
        distanceSettingStackView.goalSettingLabelStackView.addGestureRecognizer(tapGestureRecognizer)
        
        distanceSettingStackView.beforeButton.isHidden = true
        distanceSettingStackView.nextButton.addTarget(self, action: #selector(tapGoalChangeButton), for: .touchUpInside)
        
        return distanceSettingStackView
    }()
    
    lazy var timeSettingStackView: GoalSettingStackView = {
        let timeSettingStackView = GoalSettingStackView(goalType: .time)
        timeSettingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTimeLabel))
        timeSettingStackView.goalSettingLabelStackView.isUserInteractionEnabled = true
        timeSettingStackView.goalSettingLabelStackView.addGestureRecognizer(tapGestureRecognizer)
        
        timeSettingStackView.nextButton.isHidden = true
        timeSettingStackView.beforeButton.addTarget(self, action: #selector(tapGoalChangeButton), for: .touchUpInside)
        
        return timeSettingStackView
    }()
    
    lazy var underButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    lazy var startButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tabBarSelect
        button.setTitle("시작", for: .normal)
        button.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 24.0)
        
        return button
    }()
    
    //MARK: - Properties
    let viewModel: RunningStartViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setMapView()
        setStartButtonStackView()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    //MARK: - Initalizer
    init(viewModel: RunningStartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    private func bind() {
        viewModel?.goalDistance.asDriver()
            .map({String(format: "%.2f", $0)})
            .drive(distanceSettingStackView.goalSettingLabelStackView.destinationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.goalTimeRelay.asDriver()
            .drive(timeSettingStackView.goalSettingLabelStackView.destinationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Settings
    
    func setMapView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setStartButtonStackView() {
        view.addSubview(startButtonStackView)
        startButtonStackView.addArrangedSubview(distanceSettingStackView)
        startButtonStackView.addArrangedSubview(timeSettingStackView)
        timeSettingStackView.isHidden = true
        startButtonStackView.addArrangedSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButtonStackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: view.frame.height * (CGFloat(71) / CGFloat(1624))),
            startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(180) / CGFloat(1624)),
            startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor)
            
        ])
    }
    
    @objc func tapDistanceLabel() {
        presentSettingGoalView(goalType: .distance)
    }
    
    @objc func tapTimeLabel() {
        presentSettingGoalView(goalType: .time)
    }
    
    func presentSettingGoalView(goalType: GoalType) {
        let navigationVC = UINavigationController()
        navigationVC.modalPresentationStyle = .fullScreen
        navigationVC.navigationBar.titleTextAttributes = [.font: UIFont(name: "NotoSansKR-Medium", size: 20) ?? .boldSystemFont(ofSize: 20)]
        let vc = GoalSettingViewController(goalType: goalType)
        vc.delegate = self
        navigationVC.pushViewController(vc, animated: false)
        present(navigationVC, animated: false)
    }
    
    @objc func tapStartButton() {
        let vc = RecordViewController(viewModel: RecordViewModel())
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: false)
    }
    
    @objc func tapGoalChangeButton() {
        distanceSettingStackView.isHidden = !distanceSettingStackView.isHidden
        timeSettingStackView.isHidden = !timeSettingStackView.isHidden
    }
    
    deinit {
        print("deinit runningStart view")
    }
    
}

extension RunningStartViewController: GoalSettingViewDelegate {
    
    func tapSettingButton(goalType: GoalType, goal: String) {
        switch goalType {
        case .distance:
            viewModel?.goalDistance.accept(Float(goal)!)
        case .time:
            let time = goal.split(separator: ":").map {Int($0)}
            viewModel?.goalHour.accept(time[0] ?? 0)
            viewModel?.goalMinute.accept(time[1] ?? 0)
        }
    }
    
}
