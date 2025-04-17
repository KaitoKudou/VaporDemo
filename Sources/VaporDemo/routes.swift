import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello", "**") { req -> String in
        let name = req.parameters.getCatchall().joined(separator: " ")
        return "Hello, \(name)!"
    }
    
    app.get("json") { _ in
        let json = [
            "message": "Hello, Vapor!",
            "status": "success"
        ]
        let response = Response(status: .ok)
        try response.content.encode(json, as: .json)
        return response
    }
    
    app.get("image") { request async throws in
        // public ディレクトリ内にある画像へのパスを取得
        let path = app.directory.publicDirectory.appending("luffy.png")
        
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
    
    try app.register(collection: MyController())
    
    try app.register(collection: HTTPBinController())
}
