//
//  VideoGalleryViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import SnapKit
import UIKit

final class VideoGalleryViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension VideoGalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VideoCell.identifier,
                for: indexPath
            ) as? VideoCell
        else { return UITableViewCell() }
        return cell
    }
}

extension VideoGalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

@available(iOS 17.0, *)
#Preview {
    VideoGalleryViewController()
}
