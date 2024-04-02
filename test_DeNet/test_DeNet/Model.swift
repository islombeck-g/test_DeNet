import RealmSwift
import Foundation

class Node: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var children: List<Node>
    @Persisted var parent: Node?
    
    override class func primaryKey() -> String? {
        "id"
    }
}

class Node1: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var childIDs: List<ObjectId>
    @Persisted var parentID: ObjectId?

    override class func primaryKey() -> String? {
        "id"
    }
}

struct Node1ForView: Identifiable {
    var id: ObjectId
    var name: String
    var childIDs: Array<ObjectId>
    var parentID: ObjectId?
}

class AppState: Object {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var selectedNodeId: ObjectId?
}
