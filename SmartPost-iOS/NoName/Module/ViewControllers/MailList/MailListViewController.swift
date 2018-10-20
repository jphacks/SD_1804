//
//  MailListViewController.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import UIKit

class MailListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let samples = ["test1","test2","test3","test4","test5","test6","test7","test8","test9","test10","test11","test12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let test:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        let imageView = test.contentView.viewWithTag(1) as! UIImageView
        let cellImage = UIImage(named: samples[indexPath.row])
        imageView.image = cellImage
        return test
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    private func setupUI() {
        
    }
}
