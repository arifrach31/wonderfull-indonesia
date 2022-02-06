//
//  NetfoxService.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation
import netfox
import Alamofire

#if DEVELOPMENT || NETFOX

final class NetfoxService: Alamofire.SessionManager {
  static let sharedManager: NetfoxService = {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    
    let manager = NetfoxService(configuration: configuration)
    return manager
  }()
}

#endif
