//
//  OverviewTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 23/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class OverviewTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var lblLike: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  @IBOutlet weak var lblWeather: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  
  var item: Place? {
    didSet {
      setContent()
    }
  }

  func setContent() {
    lblLike.text = "\(item?.like ?? 0)"
    lblDescription.text = item?.description ?? "-"
    lblWeather.text = item?.weather ?? "-"
    lblPrice.text = item?.price ?? "$0"
  }
}
