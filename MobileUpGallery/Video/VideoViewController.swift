//
//  VideoViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import UIKit
import WebKit

protocol VideoViewControllerProtocol: AnyObject {
    func updateView(with model: DetailVideoModel)
}

final class VideoViewController: UIViewController {
    private let presenter: VideoPresenterProtocol

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    init(presenter: VideoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .share,
            style: .done,
            target: self,
            action: #selector(shareMenuTapped)
        )
        
        presenter.loadData()
    }
    
    @objc private func shareMenuTapped() {
        #warning("to do")
        let activityViewController = UIActivityViewController(
            activityItems: [],
            applicationActivities: [UIActivity()]
        )
        present(activityViewController, animated: true)
    }
}

extension VideoViewController: VideoViewControllerProtocol {
    func updateView(with model: DetailVideoModel) {
        title = model.title
        guard let url = URL(string: model.url) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

extension VideoViewController: WKNavigationDelegate {
    
}
