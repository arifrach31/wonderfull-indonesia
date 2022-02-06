//
//  AboutViewModel.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 24/01/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

class AboutViewModel {
  var isLoading: BehaviorRelay<Bool>
  var about: BehaviorRelay<About?>
  var error: BehaviorRelay<ApiError?>

  private let disposeBag = DisposeBag()

  init() {
    isLoading = BehaviorRelay(value: false)
    about = BehaviorRelay(value: nil)
    error = BehaviorRelay(value: nil)
  }

  func requestAbout() {
    isLoading.accept(true)

    GeneralInteractor.api(BaseApi.about, responseType: About.self).subscribe(onNext: {[weak self] (response) in
      self?.about.accept(response)
    }, onError: { [weak self] (er) in
      self?.error.accept(er as? ApiError)
      self?.isLoading.accept(false)
    }, onCompleted: { [weak self] in
      self?.isLoading.accept(false)
    }).disposed(by: disposeBag)
  }
}
