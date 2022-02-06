//
//  APIFactory.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation
import Moya

let _baseURL = URL(string: "https://run.mocky.io/v3/")!
public enum BaseApi {
  case destination
  case about
}

extension BaseApi: TargetType {
  public var baseURL: URL {
    #if DEVELOPMENT
      return baseURL
    #else
      return _baseURL
    #endif
  }
  
  public var path: String {
    switch self {
    case .destination:
      return "342592cf-516c-4722-b018-d27b3aab1984"
    case .about:
      return "fef338e0-dc5b-4141-9d4b-b079aede1023"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    default:
      return .get
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    default:
      return .requestParameters(parameters: [:],
                                encoding: URLEncoding.queryString)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    default:
      return getHeaders(type: .authorized)
    }
  }
}

private enum HeaderType {
  case anonymous
  case authorized
  case appToken
}

extension BaseApi {
  var endpointClosure: (BaseApi) -> Endpoint {
    return { _ in
      return MoyaProvider.defaultEndpointMapping(for: self).adding(newHTTPHeaderFields: self.headers!)
    }
  }
  
  fileprivate func getHeaders(type: HeaderType) -> [String: String] {
    var header = ["Accept": "application/json"]

    switch type {
    case .appToken:
      header["token"] = ""
    case .authorized:
      if let session = Persistent.shared.get(key: .sessionID) {
        header["token"] = "\(session)"
        print("my token is \(session)")
      }
    case .anonymous:
//      if let token = Persistent.shared.get(key: .anonimousToken) {
//        header["Authorization"] = "Bearer \(token)"
//      }
      break
    }

    #if DEVELOPMENT
    switch task {
    case .requestParameters(let parameters, _):
      header["Debug:Http-Body"] = parameters.debugDescription
    case .requestCompositeParameters(let bodyParameters, _, _):
      header["Debug:Http-Body"] = bodyParameters.debugDescription
    case .uploadMultipart(let multipart):
      let arr = multipart.map({ "\($0.name)= \($0.provider)" })
      header["Debug:Http-Multipart"] = "\(arr)"
    default:
      break
    }
    #endif
    
    return header
  }
  
  var composedUrl: URL? {
    // swiftlint:disable implicit_getter
    get {
      let endpoint = endpointClosure(self)
      
      do {
        let url = try endpoint.urlRequest().url
        return url
      } catch {
        return nil
      }
    }
  }
}

extension String {
  func multipart(withName name: String) -> MultipartFormData {
    return MultipartFormData(provider: .data(self.data(using: .utf8) ?? Data()), name: name)
  }
}
