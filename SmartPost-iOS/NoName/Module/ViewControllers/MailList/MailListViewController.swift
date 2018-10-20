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

class MailListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView:UICollectionView!
    let samples = ["test1","test2","test3","test4","test5","test6","test7","test8","test9","test10","test11","test12"]

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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let test:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let imageView = test.contentView.viewWithTag(1) as! UIImageView
        let cellImage = filteredMails.value[indexPath.row].image
        imageView.image = cellImage
        
        let label = test.contentView.viewWithTag(2) as! UILabel
        label.text = filteredMails.value[indexPath.row].date
        print(indexPath.count)
        
        return test
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMails.value.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
