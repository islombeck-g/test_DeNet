import RealmSwift
import Foundation

class NodeRealm: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var children: List<ObjectId>
    @Persisted var parentID: ObjectId?

    override class func primaryKey() -> String? {
        "id"
    }
}

struct Node: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var children: [Node] = []
    var parentID: UUID?
    
    mutating func appendChild(newChild: Node) {
        self.children.append(newChild)
    }
    mutating func removeChild(childID: UUID) {
        self.children.removeAll { child in
            child.id == childID
        }
    }
}

//
//struct NodeForView: Identifiable {
//    var id: ObjectId
//    var name: String
//    var childIDs: Array<ObjectId>
//    var parentID: ObjectId?
//}
//
class AppState: Object {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var selectedNodeId: ObjectId?
}
