//
//  VideoCell.swift
//  MobileUpGallery
//
//  Created by Natalia on 16.08.2024.
//

import SnapKit
import UIKit

final class VideoCell: UITableViewCell {
    
    static let identifier = String(describing: VideoCell.self)
    
    private let coverImageView = UIImageView()
    
    private let backgroundLabelView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = .zero
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with title: String, imageUrl: String) {
        titleLabel.text = title
        let url = URL(string: imageUrl)
        coverImageView.kf.setImage(with: url)
    }
    
    private func setViews() {
        addSubview(coverImageView)
        coverImageView.addSubview(backgroundLabelView)
        backgroundLabelView.addSubview(titleLabel)
        
        backgroundLabelView.addSubview(blurEffectView)
        backgroundLabelView.sendSubviewToBack(blurEffectView)
    }
    
    private func setConstraints() {
        coverImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(210)
        }
        
        backgroundLabelView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(12)
            $0.bottom.top.equalToSuperview().inset(4)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    VideoCell()
}
