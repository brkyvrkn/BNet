//
//  BNetManager.swift
//  BNetworking
//
//  Created by Berkay Vurkan on 11.10.2019
//  Copyright © 2019 Temp. All rights reserved.
//
// swiftlint:disable type_name

import Foundation

/// Main module to sustain the request
public protocol BNetRequestProtocol {
    associatedtype T: Codable
    var task: HTTPTask<T> { get }
    var baseURL: URL? { get }
    var path: String { get }
    var header: HTTPHeader? { get }
    var method: HTTPMethods { get }
}

internal struct BNetConfig: Codable {
    var env: String
    var baseURL: String

    init(baseURL: String, env: String) {
        self.env = env
        self.baseURL = baseURL
    }
}

/// Manage all network access, routing and coding of data
open class BNetManager {

    public static let shared = BNetManager()
    private var token: String?
    public static var environment = BNetEnvironment.development(text: "dev")
    internal var config_: BNetConfig

    init() {
        self.token = nil
        self.config_ = BNetConfig(baseURL: "", env: BNetManager.environment.value)
    }

    /// Setter for private variable
    /// - Parameter token: Authorization token
    open func setToken(_ token: String) {
        self.token = token
    }

    /// Getter for private variable
    open func getToken() -> String {
        if let token = self.token {
            return token
        }
        return ""
    }

    /// Generic function is necessary to specify the router
    ///
    /// - Parameter endpointType: Endpoint type
    /// - Returns: BNRouter object
    ///
    /// - Note: The router must be specified before create a request, i.e
    ///
    ///  ~~~~swift
    ///  let router = BNetManager.shared.accessRouter(UsersEndpoint.self)
    ///  router.request(.connections, decoded: ConnectionResponse.self, onSuccess: {(res) in
    ///     // Success scope
    ///  }, onFailure: {(err) in
    ///     // Failure scope
    ///  })
    ///  ~~~~
    open func accessRouter<T: BNetRequestProtocol>(endpointType: T.Type) -> BNRouter<T> {
        let router = BNRouter<T>()
        return router
    }
}
