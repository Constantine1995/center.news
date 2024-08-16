//
//  ApiService.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation
import Combine
import Alamofire

protocol ApiServiceNetworker {
    func apiRequestData(_ request: URLRequestConvertible) -> AnyPublisher<Result<Data, AFError>, Never>
}

final class NApiServiceNetworker: ApiServiceNetworker {
    static let shared = NApiServiceNetworker()

    private init() {}

    func apiRequestData(_ request: URLRequestConvertible) -> AnyPublisher<Result<Data, AFError>, Never> {
        return AF.request(request)
            .publishData()
            .result()
    }

    func apiUploadData(multipartFormData: MultipartFormData, with urlRequest: URLRequestConvertible) -> AnyPublisher<Result<Data, AFError>, Never> {
        return AF.upload(multipartFormData: multipartFormData, with: urlRequest)
            .publishData()
            .result()
    }
}

class CRApiService {
    let networker: ApiServiceNetworker

    init(networker: ApiServiceNetworker = NApiServiceNetworker.shared) {
        self.networker = networker
    }

    // MARK: - Perform

    func perform<T: Decodable>(apiRoute: CRApiRoute) -> AnyPublisher<T, Error> {
        let request = self.request(apiRoute: apiRoute)
            return perform(apiRoute: apiRoute, request: request)
    }

    private func perform<T: Decodable>(apiRoute: CRApiRoute, request: URLRequestConvertible) -> AnyPublisher<T, Error> {
        return networker.apiRequestData(request)
            .flatMap { [weak self] response -> AnyPublisher<T, Error> in

                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.handle(response: response)
                    .catch { error -> AnyPublisher<T, Error> in
                        return Fail(error: error).eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }


    private func handle<T: Decodable>(response: Result<Data, AFError>) -> AnyPublisher<T, Error> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: response.get())
            return Result<T, Error>.success(result).publisher.eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func request(apiRoute: CRApiRoute, timeoutInterval: Int = 120) -> URLRequest {
        let baseURL = Constants.baseURL
        var urlComps = URLComponents(string: baseURL + apiRoute.path)!
        urlComps.queryItems = apiRoute.queryParameters?.toQueryParameters()
        let url = urlComps.url!
        debugPrint("⚡️\(url.absoluteString)⚡️")
        var request = URLRequest(url: url)
        request.httpMethod = apiRoute.method.rawValue
        request.httpBody = apiRoute.body
        request.timeoutInterval = TimeInterval(timeoutInterval)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        if let parameters = apiRoute.parameters {
            let encoding: ParameterEncoding = apiRoute.method == .get ? URLEncoding.default : JSONEncoding.default
            if let encodedRequest = try? encoding.encode(request, with: parameters) {
                request = encodedRequest
            }
        }
        return request
    }
    
}
