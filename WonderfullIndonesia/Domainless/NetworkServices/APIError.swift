//
//  APIError.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation

enum ApiError: Error {
  case connectionError
  case invalidJSONError
  case middlewareError(code: Int, message: String?)
  case failedMappingError
  
  var localizedDescription: String {
    switch self {
    case .connectionError:
      return "error_connection".localized()
    case .invalidJSONError:
      return "error_json".localized()
    case .middlewareError(_, let message):
      return message ?? ""
    case .failedMappingError:
      return "error_format".localized()
    }
  }
}
