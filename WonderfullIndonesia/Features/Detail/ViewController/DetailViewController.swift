//
//  DetailViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 23/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core

class DetailViewController: UIViewController {

  @IBOutlet weak var imgCover: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var lblDetail: UILabel!
  @IBOutlet weak var lblLocation: UILabel!
  @IBOutlet weak var imgFavorite: UIImageView!
  @IBOutlet weak var imgLocation: UIImageView!
  
  private let place: Place?
  private let viewModel: DetailViewModel
  private let disposeBag = DisposeBag()
  private let backgroundColorLayer = UIColor.gradientColorPrimary

  init(place: Place?, viewModel: DetailViewModel) {
    self.place = place
    self.viewModel = viewModel

    super.init(nibName: "DetailViewController", bundle: nil)
    hidesBottomBarWhenPushed = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViews()
    observeViewModel()
    setContent()
  }

  override func viewWillAppear(_ animated: Bool) {
    setNavigationBar(type: .backAndTitle(title: "", color: .clear, backColor: .white))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    backgroundColorLayer.frame = view.bounds

    view.layer.insertSublayer(backgroundColorLayer, at: 0)
  }

  override func leftNavigationBarButtonTapped(sender: UIBarButtonItem?) {
    self.navigationController?.popViewController(animated: false)
  }

  func configureViews() {
    if #available(iOS 11.0, *) {
      imgCover.clipsToBounds = true
      imgCover.layer.cornerRadius = 50
      imgCover.layer.maskedCorners = [.layerMaxXMaxYCorner]
    } else {
      imgCover.clipsToBounds = true
      let path = UIBezierPath(roundedRect: imgCover.bounds,
                              byRoundingCorners: [.bottomRight],
                              cornerRadii: CGSize(width: 20, height: 20))
      let maskLayer = CAShapeLayer()
      maskLayer.path = path.cgPath
      imgCover.layer.mask = maskLayer
    }

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    imgFavorite.isUserInteractionEnabled = true
    imgFavorite.addGestureRecognizer(tapGestureRecognizer)
    
    imgLocation.image = UIImage.iconLocation
    tableView.dataSource = self
    
    tableView.register(cellType: OverviewTableViewCell.self)
  }

  func observeViewModel() {
    NotificationCenter.default.rx
      .notification(Notifications.favoritNotifications).subscribe(onNext: {[weak self] _ in
        self?.tableView.reloadData()
      }).disposed(by: disposeBag)
  }

  func setContent() {
    lblDetail.text = place?.name ?? "-"
    lblLocation.text = place?.address ?? "-"
    if let image = place?.image {
      imgCover.kf.setImage(with: URL(string: image))
    }
    imgFavorite.image = place?.isFavorit ?? false ? UIImage.iconIsFavoritActive : UIImage.iconIsFavoritInactive
  }

  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    guard let destination = viewModel.interactor.currentDestination() else { return }
    let isFav = viewModel.interactor.handleDestinationFav(id: place?.id ?? 0, destination: destination)
    imgFavorite.image = !isFav ? UIImage.iconIsFavoritActive : UIImage.iconIsFavoritInactive
  }
}

extension DetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: OverviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.item = place
    return cell
  }
}
