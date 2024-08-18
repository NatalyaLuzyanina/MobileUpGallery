//
//  PhotoGalleryViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import UIKit

protocol PhotoGalleryViewControllerProtocol: AnyObject {
    func updateView(with model: PhotoGalleryModel)
    func showError(title: String, message: String)
}

final class PhotoGalleryViewController: UIViewController {

    private let presenter: PhotoGalleryPresenterProtocol
    private var model: PhotoGalleryModel?
    
    init(presenter: PhotoGalleryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        presenter.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        model?.photos.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier, 
            for: indexPath
        ) as? PhotoCell
        else { return UICollectionViewCell() }
        if let item = model?.photos[indexPath.row] {
            cell.update(with: item.url)
        }
        return cell
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
            let numberOfItemsPerRow: CGFloat = 2
            let interItemSpacing: CGFloat = 4
            
            let availableWidth = collectionViewWidth - interItemSpacing
            let itemWidth = availableWidth / numberOfItemsPerRow
            return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let item = model?.photos[indexPath.row] {
            presenter.showDetailPhoto(id: item.id)
        }
    }
}

extension PhotoGalleryViewController: PhotoGalleryViewControllerProtocol {
    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func updateView(with model: PhotoGalleryModel) {
        self.model = model
        collectionView.reloadData()
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    PhotoGalleryViewController()
//}
