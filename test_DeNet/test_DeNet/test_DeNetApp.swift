import SwiftUI

@main
struct test_DeNetApp: App {
    
    @StateObject var rootNode = Node(name: "Root")
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                NodeView(node: rootNode)
            }
        }
    }
}
