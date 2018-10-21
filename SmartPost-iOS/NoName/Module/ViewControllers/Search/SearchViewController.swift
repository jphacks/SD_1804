//
//  SearchViewController.swift
//  NoName
//
//  Created by 下村一将 on 2018/10/20.
//  Copyright © 2018 守谷太一. All rights reserved.
//

import Blueprints
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController,UISearchBarDelegate{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar:UISearchBar!
    private let searchFromDateButtonItem = UIBarButtonItem(title: "受取日時で絞り込み", style: .plain, target: nil, action: nil)
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
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupUI() {
        title = "検索"
        let width = view.frame.width
        let blueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 1.0,
            itemSize: CGSize(width: width, height: width/2),
            minimumInteritemSpacing: 5.0,
            minimumLineSpacing: 5.0
        )
        collectionView.collectionViewLayout = blueprintLayout
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)

        setupDatePicker()

        fetchedMails
            .subscribe(
                onNext: { [weak self] in
                    self?.filteredMails.accept($0)
                },
                onError: { error in
                    debugLog(error, level: .error)
            }).disposed(by: disposeBag)

        filteredMails
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            }).disposed(by: disposeBag)

        navigationItem.rightBarButtonItem = searchFromDateButtonItem
    }
    private func setupSearch(){
        let confirmTextTime = 1.0
        searchBar.delegate = self
        self.searchBar.rx
            .text
            .orEmpty
            .filter{$0.count > 0}
            .debounce(confirmTextTime,scheduler: MainScheduler.instance)
            .withLatestFrom(fetchedMails){($0,$1)}
            .map{ (str,mails) -> [Mail] in
                return mails.filter{$0.name.contains(str) || $0.date.contains(str)}
            }
            .subscribe(onNext:{ [weak self] in
                self?.filteredMails.accept($0)
                self?.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
    }
    @objc private func fetch() {
        repository.fetchAllMails()
            .do(
                onCompleted: { [weak self] in
                    self?.stopLoading()
                    self?.refreshControl.endRefreshing()
                },
                onSubscribed: { [weak self] in
                    self?.startLoading()
            })
            .bind(to: fetchedMails)
            .disposed(by: disposeBag)
    }

    private func setupDatePicker() {
        let datePickerContainerView = UIView(frame: .zero)
        datePickerContainerView.backgroundColor = .white
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        let searchButton = UIButton(frame: .zero)
        searchButton.rx.tap
            .subscribe(onNext: {
                datePickerContainerView.removeFromSuperview()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let date = dateFormatter.string(from: datePicker.date)

                let mailsByDate = self.fetchedMails.value
                    .filter { $0.date == date }
                self.filteredMails.accept(mailsByDate)
            }).disposed(by: disposeBag)
        searchButton.setTitle("検索", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        datePicker.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(searchButton.snp.top)
        }
        searchFromDateButtonItem.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.view.addSubview(datePickerContainerView)
                datePickerContainerView.snp.makeConstraints {
                    $0.bottom.right.left.equalToSuperview()
                    $0.height.equalTo(200)
                }
            }).disposed(by: disposeBag)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
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


