//
//  PhotoViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import UIKit

protocol PhotoViewControllerProtocol: AnyObject {
    func updateView(with model: DetailPhotoModel)
}

final class PhotoViewController: UIViewController {

    private let presenter: PhotoPresenterProtocol
    
    private let photoImage: UIImageView = {
       let view = UIImageView()
        return view
    }()
    
    init(presenter: PhotoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .share,
            style: .done,
            target: self,
            action: #selector(sharePhoto)
        )
        view.addSubview(photoImage)
        presenter.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        photoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    @objc private func sharePhoto() {
        print(#function)
    }
}

extension PhotoViewController: PhotoViewControllerProtocol {
    func updateView(with model: DetailPhotoModel) {
        title = model.date
        let url = URL(string: model.imageUrl)
        photoImage.kf.setImage(with: url)
    }
}
