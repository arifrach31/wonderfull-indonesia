//
//  APIError.swift
//  WonderfullIndonesia
//
//  Created by ArifRachman on 08/01/22.
//  Copyright © 2022 AriifRach. All rights reserved.
//

import Foundation

public enum ApiError: Error {
  case connectionError
  case invalidJSONError
  case middlewareError(code: Int, message: String?)
  case failedMappingError
}
