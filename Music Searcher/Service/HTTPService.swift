//
//  Service.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 18.04.2022.
//

import UIKit
import Alamofire
import Foundation

protocol HttpRouter {
    var baseUrlString: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    func body() throws -> Data?
    
    func request(usingHttpService service: HttpService, addParameters: Parameters) throws -> DataRequest
}

extension HttpRouter {
    
    var headers: HTTPHeaders? { return nil }
    func body() throws -> Data? { return nil }
    
    func asUrlRequest(with addParameters: Parameters) throws -> URLRequest {
        let url = try baseUrlString.asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        let allParameters = self.parameters.merging(addParameters) { (_, new) in new }
        return try encoding.encode(request, with: allParameters)
    }
    
    func request(usingHttpService service: HttpService, addParameters: Parameters) throws -> DataRequest {
        return try service.request(asUrlRequest(with: addParameters))
    }
}

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
