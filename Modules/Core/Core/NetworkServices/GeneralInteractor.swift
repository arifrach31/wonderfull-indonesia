//
//  GeneralInteractor.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import ObjectMapper
import RxSwift

public struct GeneralInteractor {
  public static func api<T: Mappable>(_ api: BaseApi, responseType: T.Type) -> Observable<T> {
    return NetworkService.shared.connect(api: api, mappableType: responseType)
  }
}
