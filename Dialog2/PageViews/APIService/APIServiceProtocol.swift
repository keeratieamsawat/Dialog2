// APIServiceProtocol.swift
import Foundation

// MARK: - Protocol for API Service
protocol AppAPIServiceProtocol {
    func post<T: Encodable, U: Decodable>(
        endpoint: String,
        payload: T,
        token: String?,
        responseType: U.Type,
        completion: @escaping (Result<U, Error>) -> Void
    )
}
