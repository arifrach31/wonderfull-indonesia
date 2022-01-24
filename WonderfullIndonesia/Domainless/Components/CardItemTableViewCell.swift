//
//  CardItemTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 23/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class CardItemTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var imgPlace: UIImageView!
  @IBOutlet weak var lblPlace: UILabel!
  @IBOutlet weak var lblLike: UILabel!
  @IBOutlet weak var lblAddress: UILabel!
  @IBOutlet weak var imgIconFav: UIImageView!
  @IBOutlet weak var btnFav: UIButton!
  
  var selectionHandler: ((Int?) -> Void)?
  var item: Place? {
    didSet {
      setContent()
    }
  }

  func setContent() {
    if let image = item?.image {
      imgPlace.kf.setImage(with: URL(string: image))
    }
    lblPlace.text = item?.name ?? "-"
    lblLike.text = "\(item?.like ?? 0)"
    lblAddress.text = item?.address ?? "-"

    let image = item?.isFavorit ?? false ? UIImage.iconIsFavoritActive : UIImage.iconIsFavoritInactive
    imgIconFav.image = image
  }

  @IBAction func didTapBtnFavorit(_ sender: Any) {
    guard let id = item?.id else { return }
    selectionHandler?(id)
  }
}
