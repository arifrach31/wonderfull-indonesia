//
//  BigCardTableViewCell.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 09/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit
import Reusable

class BigCardTableViewCell: UITableViewCell, NibReusable {
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblDesc: UILabel!
  @IBOutlet weak var btnCard: UIButton!

  var selectionHandler: (() -> Void)?
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureViews()
  }

  func configureViews() {
    btnCard.backgroundColor = .white
  }

  @IBAction func didTapBtnCard(_ sender: Any) {
    selectionHandler?()
  }
}
