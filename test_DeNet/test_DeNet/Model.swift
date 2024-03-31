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
