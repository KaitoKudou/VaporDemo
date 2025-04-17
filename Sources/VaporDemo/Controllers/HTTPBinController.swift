//
//  HTTPBinController.swift
//  VaporDemo
//
//  Created by 工藤 海斗 on 2025/04/17.
//

import Vapor

struct HTTPBinController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let myRoutes = routes.grouped("httpbin")
        
        myRoutes.get("get", use: get)
        myRoutes.get("404", use: getStatus404)
    }
    
    /// https://httpbin.org/get のレスポンスをそのまま返す
    func get(request: Request) async throws -> ClientResponse {
        try await request.client.get("https://httpbin.org/get")
    }
    
    /// https://httpbin.org/status/404 のレスポンスをそのまま返す
    func getStatus404(request: Request) async throws -> ClientResponse {
        let response = try await request.client.get("https://httpbin.org/status/404")
        request.logger.info("status: \(response.status)") // 404 Not Found
        
        return response
    }
}
