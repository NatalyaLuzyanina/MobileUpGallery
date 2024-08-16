//
//  PhotoCell.swift
//  MobileUpGallery
//
//  Created by Natalia on 16.08.2024.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCell.self)
    
    private let imageView: UIImageView = {
        let image: UIImage = .mockImg
        
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
        
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    PhotoCell()
}
