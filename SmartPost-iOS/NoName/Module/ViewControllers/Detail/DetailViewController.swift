//
//  DetailViewController.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Foundation
import UIKit
import Rswift

class DetailViewController: UIViewController {
    static func make(mail: Mail) -> DetailViewController {
        let vc = ViewController.instantiate(DetailViewController.self)
        vc.mail = mail
        return vc
    }

    @IBOutlet private weak var mailImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    var mail: Mail!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(mail: mail)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupUI(mail: Mail) {
        mailImageView.image = UIImage(contentsOfFile: R.file.test10Png.fullName)
        dateLabel.text = Date().description
    }
}
