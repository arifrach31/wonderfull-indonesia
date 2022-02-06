//
//  OverviewTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 23/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable
import Common

class OverviewTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var imgFavorite: UIImageView!
  @IBOutlet weak var imgWeather: UIImageView!
  @IBOutlet weak var imgPriceTag: UIImageView!
  
  @IBOutlet weak var lblLike: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var lblWeather: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  
  var item: Place? {
    didSet {
      setContent()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    configureViews()
  }

  func configureViews() {
    imgFavorite.image = UIImage.iconFavoritActive
    imgWeather.image = UIImage.iconWeather
    imgPriceTag.image = UIImage.iconPriceTag
  }
  
  func setContent() {
    lblLike.text = "\(item?.like ?? 0)"
    lblDescription.text = item?.description ?? "-"
    lblWeather.text = item?.weather ?? "-"
    lblPrice.text = item?.price ?? "$0"
  }
}
