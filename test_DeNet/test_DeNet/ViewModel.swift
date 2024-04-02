import Foundation
import RealmSwift

final class ViewModel: ObservableObject {

    @Published var selectedNode: Node1?
    @Published var nodes: Array<Node1ForView> = Array<Node1ForView>()
    
    private var mainViewModel = MainViewModel.shared

    init(selectedNodeID: ObjectId) {
        
        guard let realm = try? Realm() else {
            fatalError("problems with init realm")
        }
        
        let selectedNode = realm.object(ofType: Node1.self, forPrimaryKey: selectedNodeID)
        self.selectedNode = selectedNode
        getNodesByIds()
    }



    func deleteNode(indexSet: IndexSet) {
        guard let realm = try? Realm() else { return }
        guard let index = indexSet.first else { return }

        let id = self.nodes[index].id

        try? realm.write({
            selectedNode?.childIDs.remove(at: index)
        })
        if let nodeToDelete = realm.object(ofType: Node1.self, forPrimaryKey: id) {
            self.recursiveDelete(node: nodeToDelete, realm: realm)
        }

        self.nodes.remove(at: index)
    }

    private func recursiveDelete(node: Node1, realm: Realm) {
        guard !node.childIDs.isEmpty else {
            try? realm.write({
                realm.delete(node)
            })
            return
        }
        for i in node.childIDs {
            if let nodeToDelete = realm.object(ofType: Node1.self, forPrimaryKey: i) {
                recursiveDelete(node: nodeToDelete, realm: realm)
            }
        }
        try? realm.write({
            realm.delete(node)
        })
    }

    func addChildren() {
        let newNode = Node1(value: ["_id": ObjectId.generate()])
        newNode.name = generateAddress()
        newNode.parentID = selectedNode?.id

        guard let realm = try? Realm() else { return }

        try? realm.write {
            realm.add(newNode)
            selectedNode?.childIDs.append(newNode.id)
        }
        getNodesByIds()
    }

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
    func getNodesByIds() {
        guard let realm = try? Realm() else { return }

        mainViewModel.changeLast(selectedNodeID: selectedNode?.id)

        self.nodes = []
        guard let me = self.selectedNode?.childIDs else {return}
        let ids = Array(me)
        do {
            let realm = try Realm()
            let nodes = realm.objects(Node1.self).filter("id IN %@", ids)

            for i in nodes {
                let newNode = Node1ForView(id: i.id, name: i.name, childIDs: Array(i.childIDs), parentID: i.parentID)
                self.nodes.append(newNode)
            }
        } catch {
            print("Ошибка при получении элементов: \(error)")
        }
    }
    
    
    
    
//    MARK: -
//    func nextPage(item: ObjectId?) {
//        guard let item = item else { return }
//        guard let realm = try? Realm() else { return }
//
//        let switchNode = realm.objects(Node1.self).where {
//            $0.id == item
//        }.first
//
//        self.selectedNode = switchNode!
//        getNodesByIds()
//        return
//    }
    func canNavigateBack() {
        guard let realm = try? Realm() else { return }
        guard let parentID = selectedNode?.parentID else { return  }

        let switchNode = realm.objects(Node1.self).where {
            $0.id == parentID
        }.first

        self.selectedNode = switchNode!

        getNodesByIds()
    }
}




//final class ViewModel1: ObservableObject {
//
//    @Published var selectedNode: Node1?
//    @Published var nodes: Array<Node1ForView> = Array<Node1ForView>()
//
//    private var appState: AppState?
//
//    init() {
//        guard let realm = try? Realm() else {
//            fatalError("problems with init realm")
//        }
//
//        if let appState = realm.objects(AppState.self).first {
//            self.appState = appState
//        } else {
//            self.appState = AppState()
//            try? realm.write {
//                realm.add(self.appState!)
//            }
//        }
//
//        if let selectedNodeId = appState?.selectedNodeId {
//            self.selectedNode = realm.object(ofType: Node1.self, forPrimaryKey: selectedNodeId)
//        } else {
//            if let root = realm.objects(Node1.self).first {
//                self.selectedNode = root
//            } else {
//                let root = Node1()
//                root.name = "Root"
//                self.selectedNode = root
//                try? realm.write {
//                    realm.add(root)
//                }
//            }
//        }
//        getNodesByIds()
//    }
//
//    func nextPage(item: ObjectId) -> Bool {
//        guard let realm = try? Realm() else { return false }
//
//        let switchNode = realm.objects(Node1.self).where {
//            $0.id == item
//        }.first
//
//        self.selectedNode = switchNode!
//        getNodesByIds()
//        return true
//    }
//
//    func navigateBack() -> Bool {
//        guard let realm = try? Realm() else { return false }
//        guard let parentID = selectedNode?.parentID else {
//            return false
//        }
//
//        let switchNode = realm.objects(Node1.self).where {
//            $0.id == parentID
//        }.first
//
//        self.selectedNode = switchNode!
//
//        getNodesByIds()
//        return true
//    }
//
//    func deleteNode(indexSet: IndexSet) {
//        guard let realm = try? Realm() else { return }
//        guard let index = indexSet.first else { return }
//
//        let id = self.nodes[index].id
//
//        try? realm.write({
//            selectedNode?.childIDs.remove(at: index)
//        })
//        if let nodeToDelete = realm.object(ofType: Node1.self, forPrimaryKey: id) {
//            self.recursiveDelete(node: nodeToDelete, realm: realm)
//        }
//
//        self.nodes.remove(at: index)
//    }
//
//    private func recursiveDelete(node: Node1, realm: Realm) {
//        guard !node.childIDs.isEmpty else {
//            try? realm.write({
//                realm.delete(node)
//            })
//            return
//        }
//        for i in node.childIDs {
//            if let nodeToDelete = realm.object(ofType: Node1.self, forPrimaryKey: i) {
//                recursiveDelete(node: nodeToDelete, realm: realm)
//            }
//        }
//        try? realm.write({
//            realm.delete(node)
//        })
//    }
//
//    func addChildren() {
//        let newNode = Node1(value: ["_id": ObjectId.generate()])
//        newNode.name = generateAddress()
//        newNode.parentID = selectedNode?.id
//
//        guard let realm = try? Realm() else { return }
//
//        try? realm.write {
//            realm.add(newNode)
//            selectedNode?.childIDs.append(newNode.id)
//        }
//        getNodesByIds()
//    }
//
//    private func generateAddress() -> String {
//        let bytes = Data(repeating: 0, count: 20)
//        var randomBytes = bytes
//
//        let status = randomBytes.withUnsafeMutableBytes { (bytesPointer) -> Int32 in
//            return SecRandomCopyBytes(kSecRandomDefault, 20, bytesPointer.baseAddress!)
//        }
//
//        if status == errSecSuccess {
//            let hexString = randomBytes.map { String(format: "%02hhx", $0) }.joined()
//            return "\(hexString)"
//        } else {
//            return "Error generating random bytes"
//        }
//    }
//    func getNodesByIds() {
//        guard let realm = try? Realm() else { return }
//
//        try? realm.write {
//            appState?.selectedNodeId = selectedNode?.id
//        }
//
//        self.nodes = []
//        guard let me = self.selectedNode?.childIDs else {return}
//        let ids = Array(me)
//        do {
//            let realm = try Realm()
//            let nodes = realm.objects(Node1.self).filter("id IN %@", ids)
//
//            for i in nodes {
//                let newNode = Node1ForView(id: i.id, name: i.name, childIDs: Array(i.childIDs), parentID: i.parentID)
//                self.nodes.append(newNode)
//            }
//        } catch {
//            print("Ошибка при получении элементов: \(error)")
//        }
//    }
//}
