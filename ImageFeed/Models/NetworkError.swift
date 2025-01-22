//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 16.01.2025.
//

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case unknownError(Error?)
    case invalidUrl
    case decodingError(Error?)
    case duplicate
    case noData
}
