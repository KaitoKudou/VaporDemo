//
//  OpenAPIRequestInjectionMiddleware.swift
//  VaporDemo
//
//  Created by 工藤 海斗 on 2025/04/22.
//

import Dependencies
import Vapor

struct OpenAPIRequestInjectionMiddleware: AsyncMiddleware {
    func respond(
        to request: Request,
        chainingTo responder: any AsyncResponder
    ) async throws -> Response {
        try await withDependencies {
            $0.request = request
        } operation: {
            try await responder.respond(to: request)
        }
    }
}
