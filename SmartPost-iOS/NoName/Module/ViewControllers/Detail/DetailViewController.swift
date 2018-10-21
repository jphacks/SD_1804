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
import FlexiblePageControl

class DetailViewController: UIViewController,UIScrollViewDelegate {
    static func make(mail: Mail) -> DetailViewController {
        let vc = ViewController.instantiate(DetailViewController.self)
        vc.mail = mail
        return vc
    }

    @IBOutlet private weak var mailImageView: UIView!
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
    let pageControl = FlexiblePageControl()
    let scrollView = UIScrollView()
    let numberOfPage = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(mail: mail)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupUI(mail: Mail) {
        let images = [mail.image1,mail.image2]
        scrollView.delegate = self
        scrollView.frame = mailImageView.frame
        scrollView.center = mailImageView.center
        scrollView.contentSize = CGSize(width: mailImageView.frame.width * CGFloat(numberOfPage), height: mailImageView.frame.height)
        scrollView.isPagingEnabled = true
        pageControl.numberOfPages = numberOfPage
        for index in 0..<numberOfPage{
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * mailImageView.frame.width, y: 0, width: mailImageView.frame.width, height: mailImageView.frame.height))
            view.image = images[index]
            scrollView.addSubview(view)
        }
        mailImageView.addSubview(scrollView)
        flagLabel.backgroundColor = mail.inInbox ? .red : .gray
        flagLabel.text = mail.inInbox ? "未読" : "既読"
        dateLabel.text = "\(mail.date) \(mail.time)"
        nameLabel.text = mail.name
        fromLabel.text = mail.from
    }
}
