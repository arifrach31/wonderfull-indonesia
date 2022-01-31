//
//  HomeTabBarViewController.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar()
  }
  
  override func viewWillLayoutSubviews() {
    var tabFrame = self.tabBar.frame
    tabFrame.size.height = 80
    tabFrame.origin.y = self.view.frame.size.height - 80
    self.tabBar.frame = tabFrame
  }
  
  func configureNavBar() {
    tabBar.isTranslucent = false
    tabBar.clipsToBounds = true
    tabBar.barTintColor = .white
    
    let homeController = createTabController(vc: HomeViewController(viewModel: HomeViewModel()), active: UIImage.iconHomeActive!, inactive: UIImage.iconHomeInactive!)
    let favoritController = createTabController(vc: FavoritViewController(viewModel: FavoriteViewModel()), active: UIImage.iconFavoritActive!, inactive: UIImage.iconFavoritInactive!)
    let accountController = createTabController(vc: AboutViewController(viewModel: AboutViewModel()), active: UIImage.iconAboutActive!, inactive: UIImage.iconAboutInactive!)
    
    viewControllers = [homeController, favoritController, accountController]
  }
}

extension UITabBarController {
  func createTabController(vc: UIViewController, active: UIImage, inactive: UIImage) -> UINavigationController {
    let viewController = vc
    let tabController = UINavigationController(rootViewController: viewController)
    tabController.tabBarItem.image = inactive
    tabController.tabBarItem.selectedImage = active.withRenderingMode(.alwaysOriginal)
    tabController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
    tabController.tabBarItem.title = "•"
    tabController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 2.0)
    tabController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26)], for: .normal)
    tabController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.primaryColor, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 26)], for: .selected)
    
    return tabController
  }
}

extension UINavigationController {
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
}
