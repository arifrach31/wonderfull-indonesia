//
//  PhotoTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 24/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class PhotoTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var imgPhoto: UIImageView!

  var data: Me? {
    didSet {
      setContent()
    }
  }

  func setContent() {
    if let image = data?.image {
      imgPhoto.kf.setImage(with: URL(string: image))
    }
    imgPhoto.layer.borderColor = UIColor.lineColor.cgColor
  }
}
