//
//  MyController.swift
//  VaporDemo
//
//  Created by 工藤 海斗 on 2025/04/17.
//

import Vapor

struct MyController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let myRoutes = routes.grouped("my")
        
        // パスと処理を行うメソッドを登録
        myRoutes.get("image", use: getImage)
        myRoutes.get("json", use: getJSON)
        myRoutes.get("notfound-500", use: notFound500)
        myRoutes.get("notfound", use: notFound)
    }
    
    /// ルフィの画像を返す
    func getImage(request: Request) async throws -> Response {
        // public ディレクトリ内にある画像へのパスを取得
        let path = request.application.directory.publicDirectory.appending("luffy.png")
        
        // 指定したパスの ByteBuffer を取得
        let buffer = try await request.fileio.collectFile(at: path)
        
        var headers = HTTPHeaders()
        headers.contentType = .png
        
        return Response(
            status: .ok,
            headers: headers,
            body: .init(buffer: buffer)
        )
    }
    
    /// JSON レスポンスを返す
    func getJSON(request: Request) throws -> Response {
        let json = [
            "message": "Hello, Vapor!",
            "status": "success"
        ]
        
        let response = Response(status: .ok)
        try response.content.encode(json, as: .json)
        
        return response
    }
    
    /// 存在しないリソースにアクセスすると500エラーを throw する
    func notFound500(request: Request) async throws -> Response {
        let path = request.application.directory.publicDirectory.appending("not_found_image.jpg")
        
        // 存在しないリソースにアクセスすると500エラーを throw する
        // 出力例↓
        // {"error":true,"reason":"Internal Server Error"}
        _ = try await request.fileio.collectFile(at: path)
        
        return Response(status: .ok)
    }
    
    /// 存在しないリソースにアクセスすると404エラーを throw する（カスタムエラー）
    func notFound(request: Request) async throws -> Response {
        do {
            let path = request.application.directory.publicDirectory.appending("not_found_image.jpg")
            _ = try await request.fileio.collectFile(at: path)
            
            return Response(status: .ok)
        } catch {
            // 存在しないリソースにアクセスすると404エラーを throw する
            // 出力例↓
            // {"reason":"Resource not found","error":true}
            throw Abort(.notFound, reason: "Resource not found")
        }
    }
}
