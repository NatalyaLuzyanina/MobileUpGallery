//
//  BaseViewController.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import UIKit

class BaseViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
