//
//  NetworkManager.swift
//  client
//
//  Created by 金澤帆高 on 2024/01/08.
//

import Foundation

///pathにGETリクエスト送る(クエリパラメータつけて)
func sendRequest(completion: @escaping (Result<String, Error>) -> Void) {
    if var urlComponents = URLComponents(string: "http://localhost:31577/path") {
        urlComponents.queryItems = [
            URLQueryItem(name: "message", value: "Hello Fastify")
        ]

        if let url = urlComponents.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // ここでエラーハンドリングとレスポンス処理
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    completion(.success(responseString))
                } else {
                    completion(.failure(NSError()))
                }
            }
            task.resume()
        }
    }
}

func sendTextToServer(_ text: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "http://localhost:31577/post") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = ["text": text]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    //応答があるとdataTaskのコールバックが呼ばれる
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else { return }

        if let responseText = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                completion(responseText)
            }
        }
    }.resume()
}

func fetchTextFromServer(completion: @escaping (String) -> Void) {
    guard let url = URL(string: "http://localhost:31577/get") else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { return }

        if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: String],
           let text = responseDict["text"] {
            DispatchQueue.main.async {
                completion(text)
            }
        }
    }.resume()
}

