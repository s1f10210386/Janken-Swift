import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var responseText = ""
    
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
            
            Text(responseText)
                .padding()
        }
    }
    
}




#Preview {
    ContentView()
}
