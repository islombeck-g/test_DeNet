import SwiftUI

@main
struct test_DeNetApp: App {
    
    var mainViewMode = APPStateViewModel.shared
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationView {
                NodeView(selectedNodeID: self.mainViewMode.lastOpenedNode!.id)
            }
        }
    }
}
