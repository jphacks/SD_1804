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
import RxSwift

class DetailViewController: UIViewController,UIScrollViewDelegate {
    static func make(mail: Mail) -> DetailViewController {
        let vc = ViewController.instantiate(DetailViewController.self)
        vc.mail = mail
        return vc
    }

    @IBOutlet private weak var mailImageView: UIView!
    @IBOutlet weak var descriptionViews: UIScrollView!
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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(mail: mail)
        bindUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupUI(mail: Mail) {
        let images = [mail.image1,mail.image2]
        scrollView.delegate = self
        scrollView.frame = mailImageView.bounds
        scrollView.center = CGPoint(x: view.frame.width/2, y: mailImageView.center.y)
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
        flagLabel.text = mail.inInbox ? "#未読" : "#既読"
        dateLabel.attributedText = NSAttributedString(
            string: "\(mail.date) \(mail.time)",
            attributes: [NSAttributedString.Key.underlineColor: UIColor.black,
                         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                         NSAttributedString.Key.kern: 1.5]
        )
        dateLabel.isUserInteractionEnabled = true
        nameLabel.text = mail.name
        fromLabel.text = mail.from
        
        //
        descriptionViews.delegate = self
        descriptionViews.frame = view.bounds
        descriptionViews.center = view.center
        descriptionViews.isPagingEnabled = true
        descriptionViews.contentSize = CGSize(width: view.frame.width * CGFloat(2), height: view.frame.height)
        let v1 = self.view
        let v2 = self.view
        descriptionViews.addSubview(v1!)
        descriptionViews.addSubview(v2!)
        //
        
        
        
        
    }

    private func bindUI() {
        let ad = UIApplication.shared.delegate as! AppDelegate

        let dateLabelTap = UITapGestureRecognizer(target: nil, action: nil)
        dateLabelTap.rx.event.subscribe(onNext: { [unowned self] _ in
            ad.tab.selectedIndex = 1
            let date = self.dateLabel.text!.split(separator: " ")[0]
            debugLog(date)
            ad.searchViewController.searchSubject.onNext(String(date))
        }).disposed(by: disposeBag)
        dateLabel.addGestureRecognizer(dateLabelTap)

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}
