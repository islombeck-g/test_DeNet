import RealmSwift
import Foundation

class Node: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var childIDs: List<ObjectId>
    @Persisted var parentID: ObjectId?

    override class func primaryKey() -> String? {
        "id"
    }
}

struct NodeForView: Identifiable {
    var id: ObjectId
    var name: String
    var childIDs: Array<ObjectId>
    var parentID: ObjectId?
}

class AppState: Object {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var selectedNodeId: ObjectId?
}
