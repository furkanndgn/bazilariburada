//
//  RouteEmitting.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 4.05.2025.
//

import Foundation

protocol RouteEmitting {
    associatedtype Route
    var onRoute: ((Route) -> Void)? { get set }
}
