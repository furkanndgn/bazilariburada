//
//  APIURLBuilder.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.03.2025.
//

import Foundation

struct APIURLBuilder {

    static func buildURL(for endpoint: APIEndpointProtocol) -> URL? {
        guard var baseComponents = URLComponents(string: APIConfig.staging.baseURL) else {
            return nil
        }

        let fullPath = endpoint.pathAndMethod.path
        baseComponents.path += fullPath

        if let queryItems = endpoint.queryItems {
            baseComponents.queryItems = queryItems
        }

        guard let finalURL = baseComponents.url else {
            return nil
        }

        return finalURL
    }
}
