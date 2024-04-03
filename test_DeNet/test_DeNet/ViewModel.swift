import Foundation
import RealmSwift
import Combine

final class ViewModel: ObservableObject {

    @Published var selectedNode: NodeRealm?
//    @Published var nodes = Array<Node>()
    @Published var node: Array<Node>
    
    private var mainViewModel = APPStateViewModel.shared
  
    init() {
        guard let realm = try? Realm() else {
            fatalError("problems with init realm")
        }
        let id = self.mainViewModel.getLastSelectedNodeID()
        
        let firstNode = realm.objects(NodeRealm.self).filter("id IN %@", id).first
        self.selectedNode = firstNode
        
//        readNodes()
    }

//    MARK: - operations CRD
    func createChildren() {
        let newNode = NodeRealm(value: ["_id": ObjectId.generate()])
        newNode.name = generateAddress()
        newNode.parentID = selectedNode?.id
        
        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.add(newNode)
            selectedNode?.children.append(newNode.id)
        }
        
        self.node.append(Node(id: newNode.id, name: newNode.name))
    }
    
    func updateLast() {
        mainViewModel.changeLastSelectedNodeID(lastID: self.selectedNode!.id)
    }
    
    func readNodes() {
        
        guard let me = self.selectedNode?.children else { return }
        
        let ids = Array(me)
        
        do {
            let realm = try Realm()
            let nodes = realm.objects(NodeRealm.self).filter("id IN %@", ids)

            for i in nodes {
                let newNode = Node(id: i.id, name: i.name)
                self.node.append(newNode)
            }
        } catch {
            print("Ошибка при получении элементов: \(error)")
        }
    }
    
    func deleteNode(indexSet: IndexSet) {
        guard let realm = try? Realm() else { return }
        guard let index = indexSet.first else { return }

        let id = self.node[index].id

        try? realm.write({
            selectedNode?.children.remove(at: index)
        })
        if let nodeToDelete = realm.object(ofType: NodeRealm.self, forPrimaryKey: id) {
            self.recursiveDelete(node: nodeToDelete, realm: realm)
        }
       
        self.node.remove(at: index)
    }

    private func recursiveDelete(node: NodeRealm, realm: Realm) {
        guard !node.children.isEmpty else {
            try? realm.write({
                realm.delete(node)
            })
            return
        }
        for i in node.children {
            if let nodeToDelete = realm.object(ofType: NodeRealm.self, forPrimaryKey: i) {
                recursiveDelete(node: nodeToDelete, realm: realm)
            }
        }
        try? realm.write({
            realm.delete(node)
        })
    }
//    MARK: -
    private func generateAddress() -> String {
        let bytes = Data(repeating: 0, count: 20)
        var randomBytes = bytes

        let status = randomBytes.withUnsafeMutableBytes { (bytesPointer) -> Int32 in
            return SecRandomCopyBytes(kSecRandomDefault, 20, bytesPointer.baseAddress!)
        }

        if status == errSecSuccess {
            let hexString = randomBytes.map { String(format: "%02hhx", $0) }.joined()
            return "\(hexString)"
        } else {
            return "Error generating random bytes"
        }
    }
    
//    func canNavigateBack() -> Bool {
//        if self.selectedNode!.parentID != nil { return true }
//        return false
//    }
    
    func navigateBack() {
        guard let parentID = selectedNode?.parentID else { return }
        guard let realm = try? Realm() else { return }
        
        let switchNode = realm.objects(NodeRealm.self).first {
            $0 == parentID
        }
        self.selectedNode = switchNode
        
        readNodes()
        updateLast()
    }
}
