import Foundation
import RealmSwift

final class MainViewModel: ObservableObject {
    
    static var shared = MainViewModel()
    
    var appState: AppState
    var lastOpenedNode: Node1?
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("problems with init realm")
        }
        
        if let appState = realm.objects(AppState.self).first {
            self.appState = appState
        } else {
            appState = AppState()
            try? realm.write {
                realm.add(appState)
            }
        }
        
        if appState.selectedNodeId != nil {
            let lastOpenedNode = realm.object(ofType: Node1.self, forPrimaryKey: appState.selectedNodeId )
            self.lastOpenedNode = lastOpenedNode
        } else {
            if let root = realm.objects(Node1.self).first {
                self.lastOpenedNode = root
            } else {
                let root = Node1()
                root.name = "Root"
                self.lastOpenedNode = root
                try? realm.write {
                    realm.add(root)
                }
            }
        }
    }
    
    
    func changeLast(selectedNodeID: ObjectId?) {
        guard let realm = appState.realm else { return }
        try? realm.write({
            appState.selectedNodeId = selectedNodeID
        })
    }
}
