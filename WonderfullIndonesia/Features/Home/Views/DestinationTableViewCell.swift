//
//  DestinationTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 09/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class DestinationTableViewCell: UITableViewCell, NibReusable {
  @IBOutlet weak var collectionView: UICollectionView!

  var itemFavoriteHandler: ((Int?) -> Void)?
  var itemSelectionHandler: ((Place?) -> Void)?
  var destination: Destination? {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    configureViews()
  }

  func configureViews() {
    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.register(cellType: DestinationCollectionViewCell.self)
  }

  func handleFavoritDestination(id: Int) {
    itemFavoriteHandler?(id)
  }
}

extension DestinationTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return destination?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: DestinationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = destination?.places?[indexPath.row]
    cell.selectionHandler = { [weak self] (id) in
      self?.handleFavoritDestination(id: id)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = destination?.places?[indexPath.row]
    itemSelectionHandler?(item)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 203, height: collectionView.frame.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
}
