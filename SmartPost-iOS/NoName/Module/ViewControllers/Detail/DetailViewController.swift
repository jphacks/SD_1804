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
    @IBOutlet private weak var flagLabel: UILabel! {
        didSet {
            flagLabel.layer.cornerRadius = flagLabel.frame.height / 2.0
            flagLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel!
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
        mailImageView.image = mail.image1
        flagLabel.backgroundColor = mail.inInbox ? .red : .gray
        flagLabel.text = mail.inInbox ? "未読" : "既読"
        dateLabel.text = "\(mail.date) \(mail.time)"
        nameLabel.text = mail.name
        fromLabel.text = mail.from
    }
}
