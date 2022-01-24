//
//  AboutViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 24/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AboutViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  private let viewModel = AboutViewModel()
  private let disposeBag = DisposeBag()
  private let backgroundColorLayer = UIColor.gradientColorAbout

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    observeViewModel()
    self.viewModel.requestAbout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    backgroundColorLayer.frame = view.bounds

    view.layer.insertSublayer(backgroundColorLayer, at: 0)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigationBar(type: .centerTitle(title: "", titleSize: 0, titleColor: .clear))
  }

  private func configureViews() {
    tableView.dataSource = self

    tableView.register(cellType: PhotoTableViewCell.self)
    tableView.register(cellType: ShortProfileTableViewCell.self)
  }

  private func observeViewModel() {
    viewModel.isLoading.asObservable().subscribe(onNext: { (loading) in
      loading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }).disposed(by: disposeBag)

    viewModel.error.asObservable().subscribe(onNext: { [weak self] (error) in
      self?.handleError(error: error)
    }).disposed(by: disposeBag)

    viewModel.about.asObservable().subscribe(onNext: { [weak self] response in
      self?.tableView.reloadData()
    }).disposed(by: disposeBag)
  }
}

extension AboutViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 1:
      let cell: ShortProfileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.data = viewModel.about.value?.data

      return cell
    default:
      let cell: PhotoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.data = viewModel.about.value?.data
      return cell
    }
  }
}
