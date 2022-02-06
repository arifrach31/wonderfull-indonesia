//
//  NetworkService.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import ObjectMapper
import RxSwift
import SystemConfiguration.CaptiveNetwork

final class NetworkService {
  static let shared = NetworkService()
 
  static func getNetworkManager() -> Alamofire.SessionManager {
    #if DEVELOPMENT || NETFOX
    return NetfoxService.sharedManager
    #else
    let configuration = URLSessionConfiguration.default
    return Alamofire.SessionManager(configuration: configuration)
    #endif
  }

  func connect<T: Mappable>(api: BaseApi, mappableType: T.Type) -> Observable<T> {
    let networkManager = NetworkService.getNetworkManager()
    let provider = MoyaProvider<BaseApi>(endpointClosure: api.endpointClosure, manager: networkManager)
    let subject = ReplaySubject<T>.createUnbounded()

    //    queue.addOperation {
    provider.request(api) { (result) in
      switch result {
      case .success(let value):
        do {
          guard let jsonResponse = try value.mapJSON() as? [String: Any] else {
              subject.onError(ApiError.invalidJSONError)
              return
          }

          if let success = jsonResponse["status"] as? String {
            if success != "ok" {
              subject.onError(ApiError.middlewareError(code: value.statusCode, message: jsonResponse["message"] as? String))
              return
            }
          } else if let resultMessage = jsonResponse["resultMessage"] as? String {
            if resultMessage != "success" {
              subject.onError(ApiError.middlewareError(code: value.statusCode, message: jsonResponse["message"] as? String))
              return
            }
          }

          let map = Map(mappingType: .fromJSON, JSON: jsonResponse)
          guard let responseObject = mappableType.init(map: map) else {
            subject.onError(ApiError.failedMappingError)
            return
          }

          subject.onNext(responseObject)
          subject.onCompleted()
        } catch {
          subject.onError(ApiError.invalidJSONError)
        }
      case .failure:
        subject.onError(ApiError.connectionError)
      }
    }

    return subject
  }
}
