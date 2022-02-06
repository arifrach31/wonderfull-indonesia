//
//  SearchViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 22/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class SearchViewController: UIViewController, UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!

  private let searchBar: UISearchBar = UISearchBar()
  private let backgroundColorLayer = UIColor.gradientColorPrimary
  
  private let disposeBag = DisposeBag()
  private let viewModel: SearchViewModel

  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel

    super.init(nibName: "SearchViewController", bundle: nil)
    hidesBottomBarWhenPushed = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    observeViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    setNavigationBar(type: .backAndSearch(txtField: txtFieldSearch(), backColor: .lineColor))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    backgroundColorLayer.frame = view.bounds

    view.layer.insertSublayer(backgroundColorLayer, at: 0)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func leftNavigationBarButtonTapped(sender: UIBarButtonItem?) {
    self.navigationController?.popViewController(animated: false)
  }

  func configureViews() {
    searchBar.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellType: EmptyTableViewCell.self)
    tableView.register(cellType: CardItemTableViewCell.self)
  }

  func observeViewModel() {
    viewModel.searchDestination.asObservable().subscribe(onNext: { [weak self] _ in
      self?.tableView.reloadData()
    }).disposed(by: disposeBag)

    viewModel.searchText.asObservable().subscribe(onNext: { [weak self] response in
      guard let result = response else { return }
      if result.count >= 3 {
        let destination = self?.viewModel.interactor.currentDestination()?.places?.filter { (data) -> Bool in
          data.name?.lowercased().contains(result) ?? false
        }
        self?.viewModel.searchDestination.accept(destination)
      } else {
        self?.viewModel.searchDestination.accept(nil)
      }
    }).disposed(by: disposeBag)

    NotificationCenter.default.rx
      .notification(Notifications.favoritNotifications).subscribe(onNext: {[weak self] _ in
        let destination = self?.viewModel.interactor.currentDestination()?.places?.filter { (data) -> Bool in
          data.name?.lowercased().contains(self?.viewModel.searchText.value ?? "") ?? false
        }
        self?.viewModel.searchDestination.accept(destination)
      }).disposed(by: disposeBag)
  }

  func txtFieldSearch() -> UISearchBar {
    let width = self.view.frame.width - 100
    searchBar.frame = CGRect(x: 0, y: 30, width: width, height: 55)
    if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
      textfield.textColor = UIColor.black
      textfield.backgroundColor = .white
      textfield.layer.cornerRadius = 16.0
      textfield.layer.borderWidth = 1.0
      textfield.layer.borderColor = UIColor.lineColor.cgColor
      textfield.layer.masksToBounds = true
      textfield.tintColor = .black
      textfield.leftView = nil
      textfield.leftViewMode =  UITextField.ViewMode.never
      textfield.font = .systemFont(ofSize: 16)
    }

    searchBar.placeholder = "search".localized()
    searchBar.barTintColor = UIColor.clear
    searchBar.backgroundColor = UIColor.clear
    searchBar.isTranslucent = true
    searchBar.returnKeyType = UIReturnKeyType.search
    searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
    searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
    return searchBar
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.searchText.accept(searchText.lowercased())
  }

  func navigateToDetail(_ place: Place) {
    let vc = DetailViewController(place: place, viewModel: DetailViewModel())
    self.navigationController?.pushViewController(vc, animated: false)
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.isEmptyResult(viewModel.countSearchDestination) {
      return 1
    }
    return viewModel.searchDestination.value?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.isEmptyResult(viewModel.countSearchDestination) {
      let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      if viewModel.searchDestination.value?.count ?? 0 == 0, viewModel.searchText.value?.count == 0 {
      }
      let text = viewModel.searchDestination.value?.count ?? 0 > 0 ? "search".localized() : viewModel.searchText.value?.count ?? 0 > 3 ?
        "destination_not_found".localized() : "search".localized()
      cell.lblEmpty.text = text
      cell.lblEmpty.textColor = .greyColor
      return cell
    } else {
      let cell: CardItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.item = viewModel.searchDestination.value?[indexPath.row]
      cell.imgIconFav.isHidden = true
      cell.btnFav.isHidden = true
      cell.selectionStyle = .none
      return cell
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let place = viewModel.searchDestination.value?[indexPath.row] else { return }
    self.navigateToDetail(place)
  }
}
