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

class FavoritViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let viewModel = HomeViewModel()
  private let disposeBag = DisposeBag()
  private let backgroundColorLayer = UIColor.gradientColorPrimary
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    observeViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    setNavigationBar(type: .centerTitle(title: "favorite_destination".localized(), titleSize: 18.0, titleColor: .secondaryColor))
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

  func navigateToSearch(_ viewModel: HomeViewModel) {
    let vc = SearchViewController(viewModel: viewModel)
    self.navigationController?.pushViewController(vc, animated: false)
  }

  func navigateToDetail(_ place: Place) {
    let vc = DetailViewController(place: place)
    self.navigationController?.pushViewController(vc, animated: false)
  }
}

extension FavoritViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.isEmptyResult(viewModel.countFavoritDestination) {
      return 1
    }
    let data = Destination.current?.places?.filter({ $0.isFavorit })
    return data?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.isEmptyResult(viewModel.countFavoritDestination) {
      let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.lblEmpty.text = "find_destination".localized()
      cell.lblEmpty.textColor = .greyColor
      cell.btnEmpty.isHidden = false
      cell.selectionHandler = { [weak self] in
        guard let viewModel = self?.viewModel else { return }
        self?.navigateToSearch(viewModel)
      }
      return cell
    } else {
      let cell: CardItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      let data = Destination.current?.places?.filter({ $0.isFavorit })
      cell.item = data?[indexPath.row]
      cell.selectionHandler = { [weak self] (id) in
        guard let id = id else { return }
        _ = self?.viewModel.handleDestinationFav(id)
      }
      cell.selectionStyle = .none
      return cell
    }
  }
}

extension FavoritViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = Destination.current?.places?.filter({ $0.isFavorit })
    guard let place = data?[indexPath.row] else { return }
    self.navigateToDetail(place)
  }
}
