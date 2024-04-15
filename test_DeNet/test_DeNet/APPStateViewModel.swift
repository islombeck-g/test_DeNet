import Foundation
import RealmSwift

final class APPStateViewModel: ObservableObject {
    
    static var shared = APPStateViewModel()
    
    private var appState: AppState
    private var lastSelectedNodeID: ObjectId?
    
    init() {
        print("appstate_0")
        guard let realm = try? Realm() else {
            fatalError("problems with init realm, переустановите приложение(нужно удалить полностью)")
        }
        print("appstate_1")
        if let appState = realm.objects(AppState.self).first {
            print("appstate_2")
            self.appState = appState
        } else {
            print("appstate_3")
            self.appState = AppState()
            try? realm.write ({
                realm.add(appState)
            })
        }
        print("appstate_4")
        
        if let id = appState.selectedNodeId {
            print("appstate_5")
            self.lastSelectedNodeID = id
        } else {
            let rootNode = NodeRealm()
            rootNode.name = "Root"
            
            try? realm.write({
                realm.add(rootNode)
                appState.selectedNodeId = rootNode.id
            })
            
            lastSelectedNodeID = rootNode.id
        }
    }
    
    public func getLastSelectedNodeID() -> ObjectId {
        self.lastSelectedNodeID!
    }
    public func changeLastSelectedNodeID(lastID: ObjectId) {
        guard let realm = try? Realm() else { return }
        self.lastSelectedNodeID = lastID
        
        try? realm.write({
            appState.selectedNodeId = lastID
        })
    }
    
}
