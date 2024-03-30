
class NodeModel {
    var name: String
    var children: [NodeModel]
    weak var parent: NodeModel?
    
    init(name: String, children: [NodeModel] = [], parent: NodeModel? = nil) {
        self.name = name
        self.children = children
        self.parent = parent
    }
    
    func addChild(node: NodeModel) {
        children.append(node)
        node.parent = self
    }
    
    func removeChild(node: NodeModel) {
        children = children.filter { $0 !== node }
    }
}
