//
//  ShortProfileTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 24/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class ShortProfileTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var viewBox: UIView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblJob: UILabel!
  
  var data: Me? {
    didSet {
      setContent()
    }
  }

  func setContent() {
    viewBox.layer.borderColor = UIColor.lineColor.cgColor

    lblName.text = data?.name ?? "-"
    lblJob.text = "\(data?.job ?? "-") - \(data?.company ?? "-")"
  }
}
