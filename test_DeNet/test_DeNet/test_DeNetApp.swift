import SwiftUI

@main
struct test_DeNetApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationView {
                NodeView(selectedNode: viewModel.selectedNode)
            }
        }
    }
}
