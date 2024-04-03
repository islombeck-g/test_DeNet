import Foundation
import RealmSwift
import Combine

final class ViewModel: ObservableObject {

    @Published var selectedNode: NodeRealm?
    @Published var nodes = Array<Node>()
    
    private var mainViewModel = APPStateViewModel.shared
  
    init() {
        guard let realm = try? Realm() else {
            fatalError("problems with init realm")
        }
        let id = self.mainViewModel.getLastSelectedNodeID()
        
        let firstNode = realm.objects(NodeRealm.self).filter("id IN %@", id).first
        self.selectedNode = firstNode
        
        readNodes()
    }

//    MARK: - operations CRD
    func createChildren() {
        let newNode = NodeRealm(value: ["_id": ObjectId.generate()])
        newNode.name = generateAddress()
        newNode.parentID = selectedNode?.id
        
        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.add(newNode)
            selectedNode?.childIDs.append(newNode.id)
        }
        
        self.nodes.append(NodeForView(id: newNode.id, name: newNode.name, childIDs: [], parentID: newNode.parentID))
    }
    func updateLast() { mainViewModel.changeLast(selectedNodeID: self.selectedNode?.id)}
    func readNodes() {
        self.nodes = []
        
        guard let me = self.selectedNode?.childIDs else { return }
        
        let ids = Array(me)
        do {
            let realm = try Realm()
            let nodes = realm.objects(Node.self).filter("id IN %@", ids)

            for i in nodes {
                let newNode = NodeForView(id: i.id, name: i.name, childIDs: Array(i.childIDs), parentID: i.parentID)
                self.nodes.append(newNode)
            }
        } catch {
            print("Ошибка при получении элементов: \(error)")
        }
    }
    
    func deleteNode(indexSet: IndexSet) {
        guard let realm = try? Realm() else { return }
        guard let index = indexSet.first else { return }

        let id = self.nodes[index].id

        try? realm.write({
            selectedNode?.childIDs.remove(at: index)
        })
        if let nodeToDelete = realm.object(ofType: Node.self, forPrimaryKey: id) {
            self.recursiveDelete(node: nodeToDelete, realm: realm)
        }
        self.nodes.remove(at: index)
    }

    private func recursiveDelete(node: Node, realm: Realm) {
        guard !node.childIDs.isEmpty else {
            try? realm.write({
                realm.delete(node)
            })
            return
        }
        for i in node.childIDs {
            if let nodeToDelete = realm.object(ofType: Node.self, forPrimaryKey: i) {
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
    
    func canNavigateBack() {
        guard let realm = try? Realm() else { return }
        guard let parentID = selectedNode?.parentID else { return }

        let switchNode = realm.objects(Node.self).where {
            $0.id == parentID
        }.first

        self.selectedNode = switchNode!
        
        readNodes()
        updateLast()
    }
}
