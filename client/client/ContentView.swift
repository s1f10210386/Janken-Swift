import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var responseText = ""
    @State private var fetchedText: String = "" // サーバーから取得したテキストを表示
    
    @State private var isConnected = false
    @State private var webSocketTask: URLSessionWebSocketTask?
    
    var body: some View {
        VStack {
            
            Button("Send Request to Fastify") {
                sendRequest { result in
                    switch result {
                    case .success(let response):
                        print("Response: \(response)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            
            TextField("Enter text here", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send") {
                sendTextToServer(inputText) { newText in
                    responseText = newText
                }
            }
            .padding()
            HStack{
                Button("✊") {
                    sendTextToServer("✊") { newText in
                        responseText = newText
                    }
                }
                
                
                Button("✌️") {
                    sendTextToServer("✌️") { newText in
                        responseText = newText
                    }
                }
                
                
                Button("✋") {
                    sendTextToServer("✋") { newText in
                        responseText = newText
                    }
                }
                
            }
            Text(responseText)
                .padding()
            
            Button("Fetch Latest Text") {
                fetchTextFromServer { newText in
                    fetchedText = newText
                }
            }
            .padding()
            
            Text("Latest Server Text: \(fetchedText)")
                .padding()
            
            Button("Connect"){
                connectWebSocket()
            }
            .padding()
            
            Text(isConnected ? "接続成功!" : "未接続")
            
            
        }
    }
    func connectWebSocket() {
        guard let url = URL(string: "ws://localhost:31577") else {
            print("Invalid URL")
            return
        }
        
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    DispatchQueue.main.async {
                        self.isConnected = true
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                
                receiveMessage()
            }
        }
    }
    
}




#Preview {
    ContentView()
}
