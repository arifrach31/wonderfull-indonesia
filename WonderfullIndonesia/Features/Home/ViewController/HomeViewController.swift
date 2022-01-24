//
//  HomeViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let viewModel = HomeViewModel()
  private let disposeBag = DisposeBag()
  private let backgroundColorLayer = UIColor.gradientColorPrimary

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    observeViewModel()
    reqDestination()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigationBar(type: .centerTitle(title: "title".localized(), titleSize: 18, titleColor: .secondaryColor))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    backgroundColorLayer.frame = view.bounds

    view.layer.insertSublayer(backgroundColorLayer, at: 0)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  private func reqDestination() {
    guard let _ = Persistent.shared.get(key: .firstInstall) else {
      viewModel.requestDestination()
      return
    }
  }

  private func configureViews() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(headerFooterViewType: HeaderTableViewCell.self)
    tableView.register(cellType: BigCardTableViewCell.self)
    tableView.register(cellType: DestinationTableViewCell.self)
  }

  private func observeViewModel() {
    viewModel.isLoading.asObservable().subscribe(onNext: { (loading) in
      loading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }).disposed(by: disposeBag)

    viewModel.error.asObservable().subscribe(onNext: { [weak self] (error) in
      self?.handleError(error: error)
    }).disposed(by: disposeBag)

    viewModel.destination.asObservable().subscribe(onNext: { [weak self] response in
      guard let result = response else { return }

      result.save()
      Persistent.shared.set(key: .firstInstall, value: "ok".localized())
      self?.tableView.reloadData()
    }).disposed(by: disposeBag)

    NotificationCenter.default.rx
      .notification(Notifications.favoritNotifications).subscribe(onNext: {[weak self] _ in
        self?.tableView.reloadData()
      }).disposed(by: disposeBag)
  }

  public func navigateToSearch(_ viewModel: HomeViewModel) {
    let vc = SearchViewController(viewModel: viewModel)
    self.navigationController?.pushViewController(vc, animated: false)
  }

  public func navigateToDetail(_ place: Place) {
    let vc = DetailViewController(place: place)
    self.navigationController?.pushViewController(vc, animated: false)
  }
}

extension HomeViewController:  UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell: BigCardTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.selectionHandler = { [weak self] in
        guard let viewModel = self?.viewModel else { return }
        self?.navigateToSearch(viewModel)
      }
      return cell
    default:
      let cell: DestinationTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.destination = Destination.current
      cell.itemFavoriteHandler = { [weak self] (id) in
        guard let id = id else { return }
        _ = self?.viewModel.handleDestinationFav(id)
      }
      cell.itemSelectionHandler = { [weak self] (place) in
        guard let place = place else { return }
        self?.navigateToDetail(place)
      }
      return cell
    }
  }
}

extension HomeViewController:  UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableViewCell.reuseIdentifier) as? HeaderTableViewCell
    switch section {
    case 1:
      header?.lblHeader.text = "recomendation".localized()
      return header
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 1:
      return 25
    default:
      return 0.01
    }
  }
}
