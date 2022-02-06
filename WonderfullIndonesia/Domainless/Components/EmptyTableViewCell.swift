//
//  EmptyTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 22/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable
import Common

class EmptyTableViewCell: UITableViewCell, NibReusable {
  
  @IBOutlet weak var imgEmpty: UIImageView!
  @IBOutlet weak var lblEmpty: UILabel!
  @IBOutlet weak var btnEmpty: UIButton!

  var selectionHandler: (() -> Void)?
  override func awakeFromNib() {
    super.awakeFromNib()

    configureViews()
  }

  func configureViews() {
    btnEmpty.layer.borderColor = UIColor.primaryColor.cgColor
    imgEmpty.image = UIImage.iconFindPlace
  }

  @IBAction func didTapBtnEmpty(_ sender: Any) {
    selectionHandler?()
  }
}
