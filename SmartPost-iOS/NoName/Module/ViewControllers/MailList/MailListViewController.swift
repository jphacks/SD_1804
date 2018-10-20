//
//  MailListViewController.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import UIKit
import Blueprints
import RxSwift
import RxCocoa

class MailListViewController: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let refreshControl = UIRefreshControl()

    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    private let fetchedMails = BehaviorRelay<[Mail]>(value: [])
    private var filteredMails = BehaviorRelay<[Mail]>(value: [])

    private let repository = MailRepository()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func selectedSwitch(_ sender: UISegmentedControl) {
        selectedIndex.accept(sender.selectedSegmentIndex)
    }

    private func setupUI() {
        title = "マイポスト"
        let width = view.frame.width
        let blueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 1,
            itemSize: CGSize(width: width, height: width/2),
            minimumInteritemSpacing: 5.0,
            minimumLineSpacing: 5.0
        )
        collectionView.collectionViewLayout = blueprintLayout
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        
        Observable.merge(
            selectedIndex.asObservable(),
            fetchedMails.map { _ in 0 }
            )
            .withLatestFrom(fetchedMails) { ($0, $1) }
            .map { (index, mails) -> [Mail] in
                if index == 0 {
                    // unread
                    return mails.filter { $0.inInbox  }
                } else {
                    return mails.filter { !$0.inInbox }
                }
            }
            .subscribe(
                onNext: { [weak self] in
                    self?.filteredMails.accept($0)
                    self?.collectionView.reloadData()
                },
                onError: { error in
                    print(error)
            }).disposed(by: disposeBag)
    }

    @objc private func fetch() {
        repository.fetchAllMails()
            .do(onCompleted: { [weak self] in
                self?.stopLoading()
                self?.refreshControl.endRefreshing()
            }, onSubscribed: { [weak self] in
                self?.startLoading()
            })
            .bind(to: fetchedMails)
            .disposed(by: disposeBag)
    }
}

extension MailListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let test: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let imageView1 = test.contentView.viewWithTag(1) as! UIImageView
        let imageView2 = test.contentView.viewWithTag(2) as! UIImageView
        let titleLabel = test.contentView.viewWithTag(3) as! UILabel
        let mail = filteredMails.value[indexPath.row]
        imageView1.image = mail.image1
        imageView2.image = mail.image2
        titleLabel.text = mail.name

        return test
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMails.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController.make(mail: filteredMails.value[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}
