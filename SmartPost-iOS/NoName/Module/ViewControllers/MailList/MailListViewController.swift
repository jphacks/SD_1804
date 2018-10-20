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
    let samples = [Mail.init(date: "date", from: "hoge", name: "name", src: "src", time: "time", type: "type")]

    private let fetchedMails = PublishRelay<[Mail]>()
    private var filteredMails: Observable<[Mail]> {
        return fetchedMails.map { $0.filter { $0.isInbox } }
    }

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

    private func setupUI() {
        let size = view.frame.width/3.0
        let blueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 3.0,
            itemSize: CGSize(width: size, height: size),
            minimumInteritemSpacing: 5,
            minimumLineSpacing: 5
        )
        collectionView.collectionViewLayout = blueprintLayout
    }

    private func fetch() {
        repository.fetchAllMails()
            .bind(to: fetchedMails)
            .disposed(by: disposeBag)
    }
}

extension MailListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let test:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let imageView = test.contentView.viewWithTag(1) as! UIImageView
        let cellImage = UIImage(named: "test1")
        imageView.image = cellImage

        let label = test.contentView.viewWithTag(2) as! UILabel
        label.text = "sample"

        return test
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController.make(mail: samples[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}
