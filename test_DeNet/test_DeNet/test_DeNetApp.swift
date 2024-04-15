import SwiftUI

enum navPath: Hashable {
    case home
}
@main
struct test_DeNetApp: App {

    private var appState = APPStateViewModel.shared
    @StateObject private var viewModel = ViewModel()
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationStack(path: self.$viewModel.navigationPath) {
                NodeView()
                    .navigationDestination(for: self.$viewModel.navigationPath) { path in
                        NodeView()
                    }
            }
            .environmentObject(self.viewModel)
        }
    }
}

