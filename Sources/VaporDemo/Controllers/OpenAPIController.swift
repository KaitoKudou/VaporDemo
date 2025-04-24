//
//  OpenAPIController.swift
//  VaporDemo
//
//  Created by 工藤 海斗 on 2025/04/22.
//

import Dependencies
import OpenAPIRuntime
import OpenAPIVapor
@preconcurrency import Vapor
import NIOFileSystem


struct OpenAPIController: APIProtocol {
    @Dependency(\.request) var request
    
    func getGreeting(_ input: Operations.getGreeting.Input) async throws -> Operations.getGreeting.Output {
        let name = input.query.name ?? "Stranger"
        let greeting = Components.Schemas.Greeting(message: "Hello, \(name)!")
        return .ok(.init(body: .json(greeting)))
    }
    
    func getJson(_ input: Operations.getJson.Input) async throws -> Operations.getJson.Output {
        return .ok(
            .init(
                body: .json(
                    .init(message: "Hello, Vapor!", status: "success")
                )
            )
        )
    }
    
    func getImage(_ input: Operations.getImage.Input) async throws -> Operations.getImage.Output {
        // public ディレクトリ内にある画像へのパスを取得
        let path = request.application.directory.publicDirectory.appending("luffy.png")
        
        // 指定したパスの ByteBuffer を取得
        var buffer = try await request.fileio.collectFile(at: path)
        
        // 最終的に返す `Operations.getImage.OutPut.OK.Body.png` は
        // `OpenAPIRuntime.HTTPBody` を求めているため、ByteBuffer から Data を生成する
        guard let data = buffer.readData(
            length: buffer.readableBytes,
            byteTransferStrategy: .noCopy
        ) else {
            throw Abort(.badRequest)
        }
        
        return .ok(
            .init(
                body: .png(
                    .init(data)
                )
            )
        )
    }
    
    func getImageWithChunks(_ input: Operations.getImageWithChunks.Input) async throws -> Operations.getImageWithChunks.Output {
        // public ディレクトリ内にある画像へのパスを取得
        let path = request.application.directory.publicDirectory.appending("luffy.png")
        
        // ファイルから Content-Length を取得する
        let length: HTTPBody.Length = switch try await FileSystem.shared.info(forFileAt: .init(path))?.size {
        case let size?:
                .known(size)
        default:
                .unknown
        }
        
        // chunks の型は `AsyncSequence<ByteBuffer, any Error>`
        let chunks = try await request.fileio.readFile(at: path)
        
        // HTTPBody で使用できる型にするために
        // `AsyncMapSequence<FileIO.FileChunks, [UInt8]>` に変換
        let bytes = chunks.map {
            $0.getBytes(at: 0, length: $0.readableBytes) ?? []
        }
        
        let body = HTTPBody(
            bytes,
            length: length,
            iterationBehavior: .single
        )
        
        return .ok(
            .init(
                body: .png(body)
            )
        )
    }
}
