import SwiftUI

@main
struct test_DeNetApp: App {
    
    @StateObject var viewMode = ViewModel()
    
    var body: some Scene {
        
        let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            NavigationView {
                NodeView()     
            }
            .environmentObject(viewMode)
        }
    }
}
