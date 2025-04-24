//
//  DependencyValues+Live.swift
//  VaporDemo
//
//  Created by 工藤 海斗 on 2025/04/22.
//

import Dependencies
import Vapor

extension DependencyValues {
    var request: Request {
        get { self[RequestKey.self] }
        set { self[RequestKey.self] = newValue }
    }
    
    private enum RequestKey: DependencyKey {
        static var liveValue: Request {
            // リクエストごとに DI されるため、 liveValue が存在しない設計になっている
            fatalError("Value of type \(Value.self) is not registered in this context")
        }
    }
}
