//
//  PhotoViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import UIKit

protocol PhotoViewControllerProtocol: AnyObject {
    func updateView(with model: DetailPhotoModel)
    func showError(_ error: ErrorModel)
}

final class PhotoViewController: UIViewController {

    private let presenter: PhotoPresenterProtocol
    
    private let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        guard let image = photoImage.image else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: [UIActivity()]
        )
        activityViewController.completionWithItemsHandler = { _, success, _, error in
            if let error = error {
                self.showAlert(
                    title: Strings.Error.commonError,
                    message: error.localizedDescription,
                    needsOkAction: false
                )
            }
        }
        present(activityViewController, animated: true)
    }
}

extension PhotoViewController: PhotoViewControllerProtocol {
    func updateView(with model: DetailPhotoModel) {
        title = model.date
        let url = URL(string: model.imageUrl)
        photoImage.kf.setImage(with: url)
    }
    
    func showError(_ error: ErrorModel) {
        showAlert(title: error.title, message: error.message)
    }
}
