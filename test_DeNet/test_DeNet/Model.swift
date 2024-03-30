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





//MARK: -
//class NodeModel1 {
//    var name: String
//    var children: [NodeModel]
//    weak var parent: NodeModel?
//    
//    init(name: String, children: [NodeModel] = [], parent: NodeModel? = nil) {
//        self.name = name
//        self.children = children
//        self.parent = parent
//    }
//    
//    func addChild(node: NodeModel) {
//        children.append(node)
//        node.parent = self
//    }
//    
//    func removeChild(node: NodeModel) {
//        children = children.filter { $0 !== node }
//    }
//}
