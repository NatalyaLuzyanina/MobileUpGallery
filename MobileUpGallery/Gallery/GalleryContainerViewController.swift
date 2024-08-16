//
//  GalleryContainerViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import UIKit

final class GalleryContainerViewController: UIViewController {
    
    private enum Tab: Int {
        case photo
        case video
    }
    
    private var currentViewController: UIViewController?
    
    private let contentView = UIView()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            Strings.Gallery.photo,
            Strings.Gallery.video
        ])
        control.selectedSegmentIndex = Tab.photo.rawValue
        control.addTarget(self,
                          action: #selector(switchTabs),
                          for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.Gallery.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Strings.Gallery.logOut,
            style: .plain,
            target: self,
            action: #selector(logOutButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(contentView)
        displayCurrent(tab: .photo)
    }
    
    @objc private func logOutButtonTapped() {
        print(#function)
    }
    
    @objc private func switchTabs() {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        let index = segmentedControl.selectedSegmentIndex
        if let selectedTab = Tab(rawValue: index) {
            displayCurrent(tab: selectedTab)
        }
    }
    
    private func displayCurrent(tab: Tab){
        var vc: UIViewController
        let photoVC = PhotoGalleryViewController()
        let videoVC = VideoGalleryViewController()
        
        switch tab {
        case .photo:
            vc = photoVC
        case .video:
            vc = videoVC
        }
        
        addChild(vc)
        vc.didMove(toParent: self)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        currentViewController = vc
    }
    
    override func viewWillLayoutSubviews() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    GalleryContainerViewController()
}
