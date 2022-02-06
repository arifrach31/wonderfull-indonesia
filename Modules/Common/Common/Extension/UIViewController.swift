//
//  UIViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import UIKit
import SnapKit
import ShimmerSwift
import Core

// MARK: - Handle NavigationBar

public enum NavigationBarType {
  case backAndTitle(title: String?, color: UIColor?, backColor: UIColor)
  case centerTitle(title: String?, titleSize: CGFloat?, titleColor: UIColor?)
  case backAndSearch(txtField: UISearchBar?, backColor: UIColor)
}

public protocol NavigationBarButtonHandler {
  func rightNavigationBarButtonTapped(sender: UIBarButtonItem?)
  func leftNavigationBarButtonTapped(sender: UIBarButtonItem?)
}

public extension UIViewController {
  private func setDefaultNavigationTheme() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor  = UIColor.primaryViewBackgroundColor
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }

  private func setTransparentNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    navigationController?.navigationBar.isTranslucent = true
  }

  func setNavigationBar(type: NavigationBarType) {
    setTransparentNavigationBar()

    switch type {
    case .backAndTitle(let title, let color, let backColor):
      if let theTitle = title, let titleColor = color {
        navigationItem.leftBarButtonItems = [createBackButton(tintColor: backColor), createTitleLabel(title: theTitle, color: titleColor)]
      } else {
        navigationItem.leftBarButtonItem = createBackButton(tintColor: backColor)
      }
    case .centerTitle(let title, let titleSize, let titleColor):
      setTransparentNavigationBar()
      if let theTitle = title, let titleSize = titleSize, let titleColor = titleColor {
        let lblTitle = UILabel()
        lblTitle.text = theTitle
        lblTitle.font = .boldSystemFont(ofSize: titleSize)
        lblTitle.textColor = titleColor
        navigationItem.titleView = lblTitle
      }
    case .backAndSearch(let txtField, let backColor):
      setTransparentNavigationBar()
      navigationItem.leftBarButtonItems = [createBackButtonRounded(tintColor: backColor), createTextField(textField: txtField)]
    }
  }

  private func createTitleLabel(title: String, color: UIColor) -> UIBarButtonItem {
    let titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 16)
    titleLabel.text = title
    titleLabel.textColor = color
    return UIBarButtonItem(customView: titleLabel)
  }

  private func createBackButton(tintColor: UIColor) -> UIBarButtonItem {
    let backButton = UIBarButtonItem(image: UIImage.iconBackBlack,
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.leftNavigationBarButtonTapped(sender:)))
    backButton.tintColor = tintColor
    return backButton
  }

  private func createBackButtonRounded(tintColor: UIColor) -> UIBarButtonItem {
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
    backButton.tintColor = tintColor
    backButton.backgroundColor = UIColor.white
    backButton.setImage(UIImage.iconBackBlack, for: .normal)
    backButton.layer.borderColor = UIColor.lineColor.cgColor
    backButton.layer.borderWidth = 1.0
    backButton.layer.cornerRadius = 18.0
    backButton.layer.masksToBounds = true
    backButton.addTarget(self, action: #selector(self.leftNavigationBarButtonTapped(sender:)), for: .touchUpInside)
    return UIBarButtonItem(customView: backButton)
  }

  private func createTextField(textField: UISearchBar?) -> UIBarButtonItem {
    return UIBarButtonItem(customView: textField!)
  }
}

extension UIViewController: NavigationBarButtonHandler {
  @objc open func rightNavigationBarButtonTapped(sender: UIBarButtonItem?) {
    let transition = CATransition()
    transition.duration = 0.3
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.fade
    self.navigationController?.view.layer.add(transition, forKey: nil)
  }

  @objc open func leftNavigationBarButtonTapped(sender: UIBarButtonItem?) {
    let transition = CATransition()
    transition.duration = 0.3
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.fade
    self.navigationController?.view.layer.add(transition, forKey: nil)
  }
}

// MARK: - Handle Alert

public extension UIViewController {
  func showAlert(title: String?, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "ok".localized(identifier: "com.wonderfull.indonesia.Common"), style: .destructive, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Handle Error API

public extension UIViewController {
  func handleError(error: ApiError?) {
    guard let apiError = error else {
      return
    }

    showAlert(title: "failed".localized(identifier: "com.wonderfull.indonesia.Common"), message: apiError.localizedDescription)
  }
}

// MARK: - Handle Shimmer Effect

public enum ShimmerImageType {
  case home
}

public extension UIViewController {
  private func getImageWithTemplate(template: ShimmerImageType) -> UIImage? {
    switch template {
    case .home:
      return UIImage.shimmerHome
    }
  }
  
  func showShimmer(with template: ShimmerImageType) {
    let imageView = UIImageView(image: getImageWithTemplate(template: template))
    imageView.frame = view.bounds
    imageView.contentMode = .scaleToFill
    
    let shimmer = ShimmeringView()
    shimmer.tag = -1
    view.addSubview(shimmer)
    shimmer.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      if #available(iOS 11.0, *) {
        $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
          .offset(-5)
      } else {
        $0.top.equalTo(view.layoutMarginsGuide.snp.topMargin)
          .offset(-5)
      }
    }
    shimmer.contentView = imageView
    shimmer.shimmerSpeed = 540
    
    shimmer.isShimmering = true
  }
  
  func hideShimmer() {
    let shimmer = view.viewWithTag(-1) as? ShimmeringView
    shimmer?.isShimmering = false
    shimmer?.removeFromSuperview()
  }
}
