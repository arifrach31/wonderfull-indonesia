//
//  DestinationCollectionViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 09/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class DestinationCollectionViewCell: UICollectionViewCell, NibReusable {

  @IBOutlet weak var imgDestination: UIImageView!
  @IBOutlet weak var lblDestination: UILabel!
  @IBOutlet weak var btnFavorit: UIButton!
  @IBOutlet weak var imgIconFav: UIImageView!

  var selectionHandler: ((Int) -> Void)?
  var item: Place? {
    didSet {
      setContent()
    }
  }

  func setContent() {
    if let image = item?.image {
      imgDestination.kf.setImage(with: URL(string: image))
    }
    lblDestination.text = item?.name ?? "-"

    let image = item?.isFavorit ?? false ? UIImage.iconIsFavoritActive : UIImage.iconIsFavoritInactive
    imgIconFav.image = image
  }

  @IBAction func didTapBtnFavorit(_ sender: Any) {
    guard let item = item?.id else { return }
    selectionHandler?(item)
  }
}
