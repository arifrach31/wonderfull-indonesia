//
//  FavoritViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 23/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core

class FavoritViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let backgroundColorLayer = UIColor.gradientColorPrimary
  
  private let disposeBag = DisposeBag()
  private let viewModel: FavoriteViewModel
  
  init(viewModel: FavoriteViewModel) {
    self.viewModel = viewModel

    super.init(nibName: "FavoritViewController", bundle: nil)
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
    setNavigationBar(type: .centerTitle(title: "favorite_destination".localized(identifier:
                                                                                  "com.wonderfull.indonesia.Common"),
                                        titleSize: 18.0, titleColor: .secondaryColor))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    backgroundColorLayer.frame = view.bounds

    view.layer.insertSublayer(backgroundColorLayer, at: 0)
  }

  func configureViews() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(cellType: EmptyTableViewCell.self)
    tableView.register(cellType: CardItemTableViewCell.self)
  }

  func observeViewModel() {
    NotificationCenter.default.rx
      .notification(Notifications.favoritNotifications).subscribe(onNext: {[weak self] _ in
        self?.tableView.reloadData()
      }).disposed(by: disposeBag)
  }

  func navigateToSearch(_ viewModel: SearchViewModel) {
    let vc = SearchViewController(viewModel: viewModel)
    self.navigationController?.pushViewController(vc, animated: false)
  }

  func navigateToDetail(_ place: Place) {
    let vc = DetailViewController(place: place, viewModel: DetailViewModel())
    self.navigationController?.pushViewController(vc, animated: false)
  }
}

extension FavoritViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.isEmptyResult(viewModel.countFavoritDestination) {
      return 1
    }
    guard let destination = viewModel.interactor.currentDestination() else { return 0 }
    let data = destination.places?.filter({ $0.isFavorit })
    return data?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.isEmptyResult(viewModel.countFavoritDestination) {
      let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.lblEmpty.text = "find_destination".localized(identifier: "com.wonderfull.indonesia.Common")
      cell.lblEmpty.textColor = .greyColor
      cell.btnEmpty.isHidden = false
      cell.selectionHandler = { [weak self] in
        self?.navigateToSearch(SearchViewModel())
      }
      return cell
    } else {
      let cell: CardItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      guard let destination = viewModel.interactor.currentDestination() else { return cell }
      let data = destination.places?.filter({ $0.isFavorit })
      cell.item = data?[indexPath.row]
      cell.selectionHandler = { [weak self] (id) in
        guard let id = id else { return }
        _ = self?.viewModel.interactor.handleDestinationFav(id: id, destination: destination)
      }
      cell.selectionStyle = .none
      return cell
    }
  }
}

extension FavoritViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = viewModel.interactor.currentDestination()?.places?.filter({ $0.isFavorit })
    guard let place = data?[indexPath.row] else { return }
    self.navigateToDetail(place)
  }
}
