//
//  ApiResult.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation

enum ApiResult<T> {
    case initial
    case loading
    case success(_ body: T)
    case error(_ apiError: ApiError, _ message: String)
}

extension ApiResult {
    
    @discardableResult
    func onSuccess(_ block: @escaping (_ data: T) -> ()) -> ApiResult<T> {
        if case let .success(body) = self {
            block(body)
        }
        return self
    }
    
    @discardableResult
    func onError(_ block: @escaping (_ apiError: ApiError, _ message: String) -> ()) -> ApiResult<T> {
        if case let .error(code, message) = self {
            block(code, message)
        }
        return self
    }
    
    @discardableResult
    func onLoading(_ block: @escaping () -> ()) -> ApiResult<T> {
        if case .loading = self {
            block()
        }
        return self
    }
    
    @discardableResult
    func mapSuccess<X>(_ block: @escaping (_ data: T) -> X) -> ApiResult<X> {
        if case let .success(body) = self {
            return .success(block(body))
        }
        return self as! ApiResult<X>
    }
}
