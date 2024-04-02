import Foundation
import RealmSwift

final class APPStateViewModel: ObservableObject {
    
    static var shared = APPStateViewModel()
    
    var appState: AppState
    var lastOpenedNode: Node?
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("problems with init realm, переустановите приложение(нужно удалить полностью)")
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
            let lastOpenedNode = realm.object(ofType: Node.self, forPrimaryKey: appState.selectedNodeId )
            self.lastOpenedNode = lastOpenedNode
        } else {
            if let root = realm.objects(Node.self).first {
                self.lastOpenedNode = root
            } else {
                let root = Node()
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
