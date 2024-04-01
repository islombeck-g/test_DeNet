import SwiftUI

@main
struct test_DeNetApp: App {
    
    @StateObject var viewModel = ViewModel1()
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationView {
                NodeView()
                    .transition(.move(edge: .leading))
            }
            .environmentObject(self.viewModel)
        }
    }
}
