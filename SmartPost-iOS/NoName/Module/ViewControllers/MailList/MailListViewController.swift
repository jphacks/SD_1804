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
        sender.rx.controlEvent(.valueChanged)
            .map { sender.selectedSegmentIndex }
            .bind(to: selectedIndex)
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        let size = view.frame.width/3.0
        let blueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 3.0,
            itemSize: CGSize(width: size, height: size),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10
        )
        collectionView.collectionViewLayout = blueprintLayout
        
        selectedIndex
            .map { [fetchedMails] index in
                fetchedMails.value.filter { _ in index == 0 }
            }
            .subscribe(onNext: { [filteredMails] in
                filteredMails.accept($0)
                print(self.selectedIndex.value)
            })
            .disposed(by: disposeBag)
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
        let cellImage = filteredMails.value[indexPath.row].image
        imageView.image = cellImage
        return test
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMails.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController.make(mail: samples[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}
