//
//  VideoGalleryViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import SnapKit
import UIKit

protocol VideoGalleryViewControllerProtocol: AnyObject {
    func updateView(with model: VideoGalleryModel)
}

final class VideoGalleryViewController: UIViewController {
    
    private let presenter: VideoGalleryPresenterProtocol
    private var model: VideoGalleryModel?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
        return tableView
    }()
    
    init(presenter: VideoGalleryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        presenter.loadData()
    }
    
    override func viewWillLayoutSubviews() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension VideoGalleryViewController: VideoGalleryViewControllerProtocol {
    func updateView(with model: VideoGalleryModel) {
        self.model = model
        tableView.reloadData()
    }
}

extension VideoGalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.videos.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VideoCell.identifier,
                for: indexPath
            ) as? VideoCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let item = model?.videos[indexPath.row] {
            cell.configureView(with: item.title, imageUrl: item.url)
        }
        return cell
    }
}

extension VideoGalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = model?.videos[indexPath.row].id else { return }
        presenter.showVideo(with: id)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    VideoGalleryViewController()
//}
