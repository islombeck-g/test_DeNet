import Foundation
import RealmSwift

final class APPStateViewModel: ObservableObject {
    
    static var shared = APPStateViewModel()
    
    private var appState: AppState
    private var lastSelectedNodeID: ObjectId?
   
    init() {
        guard let realm = try? Realm() else {
            fatalError("problems with init realm, переустановите приложение(нужно удалить полностью)")
        }
        
        if let appState = realm.objects(AppState.self).first {
            self.appState = appState
        } else {
            self.appState = AppState()
            try? realm.write ({
                realm.add(appState)
            })
            
        }
        if let id = appState.selectedNodeId {
            self.lastSelectedNodeID = id
        } else {
            let rootNode = NodeRealm()
            rootNode.name = "Root"

            try? realm.write({
                realm.add(rootNode)
            })
            lastSelectedNodeID = rootNode.id
        }
    }
    public func getLastSelectedNodeID() -> ObjectId {
        self.lastSelectedNodeID!
    }
    public func changeLastSelectedNodeID(lastID: ObjectId) {
        self.lastSelectedNodeID = lastID
    }
}
