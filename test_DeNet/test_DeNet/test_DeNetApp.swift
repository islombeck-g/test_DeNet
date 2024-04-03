import SwiftUI

@main
struct test_DeNetApp: App {

    private var appState = APPStateViewModel.shared
    @StateObject private var veiwModel = ViewModel()
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationStack {
                NodeView()
            }
            
        }
    }
}
