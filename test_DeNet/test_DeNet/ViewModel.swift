import Foundation
import RealmSwift
import Combine

final class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
        
        @Published var nodes: List<Node>
        @Published var selectedNode: Node? {
            didSet {
                self.nodes = selectedNode?.children ?? List<Node>()
                observeChildNodes()
            }
        }
        
        private var token: NotificationToken?
        private var realm: Realm?
        
        init(selectedNode: Node? = nil) {
            let realm = try? Realm()
                self.realm = realm

                if let selectedNode = selectedNode {
                    self.selectedNode = selectedNode
                    self.nodes = selectedNode.children
                } else if let root = realm?.objects(Node.self).first {
                    self.selectedNode = root
                    self.nodes = root.children
                } else {
                    let root = Node()
                    root.name = "Root"
                    self.selectedNode = root
                    self.nodes = root.children

                    // Now that all properties are initialized, we can capture `self` in the closure
                    try? realm?.write {
                        realm?.add(root)
                    }
                }
            observeChildNodes()
        }
        
        private func observeChildNodes() {
            token?.invalidate()
            token = selectedNode?.children.observe { [weak self] changes in
                switch changes {
                case .initial, .update:
                    self?.objectWillChange.send()
                case .error(let error):
                    print("Error: \(error)")
                }
            }
        }
    func deleteNode(at indexSet: IndexSet) {
        if let index = indexSet.first, let realm = nodes[index].realm {
            try? realm.write({
                realm.delete(nodes[index])
            })
        }
    }
    
    func addChild () {
        
        let newNode = Node()
        newNode.name = generateAddress()
        newNode.parent = self.selectedNode
        
        if let realm = selectedNode?.realm {
            try? realm.write({
                print("i am here")
                selectedNode?.children.append(newNode)
            })
        }
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
    
    deinit {
        token?.invalidate()
    }
}





final class ViewModel1: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nodes = List<Node>()
    @Published var selectedNode: Node? = nil
    
    var token: NotificationToken? = nil
    
    init(selectedNode: Node? = nil) {
        self.selectedNode = selectedNode
        self.nodes = selectedNode?.children ?? List<Node>()
        let realm = try? Realm()
        if let nodes = realm?.objects(Node.self).first {
            self.selectedNode = nodes
            self.nodes = nodes.children
        } else {
            try? realm?.write({
                let group = Node()
                group.name = "Root"
                group.parent = nil
                realm?.add(group)
                self.selectedNode = group
            })
            
        }
        token = selectedNode?.children.observe({ (changes: RealmCollectionChange<List<Node>>) in
            switch changes {
            case .error(_):
                break
            case .initial:
                break
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.objectWillChange.send()
            }
        })
    }
    func deleteNode(at indexSet: IndexSet) {
        if let index = indexSet.first, let realm = nodes[index].realm {
            try? realm.write({
                realm.delete(nodes[index])
            })
        }
    }
    
    func addChild () {
        
        let newNode = Node()
        newNode.name = generateAddress()
        newNode.parent = self.selectedNode
        
        if let realm = selectedNode?.realm {
            try? realm.write({
                print("i am here")
                selectedNode?.children.append(newNode)
            })
        }
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
    
    deinit {
        token?.invalidate()
    }
}

//    func setupNodesObservation() {
//        
//        do {
//            let realm = try Realm()
//            let results = realm.objects(Node.self)
//            // Подписка на изменения
//            notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//                switch changes {
//                case .initial(let results), .update(let results, deletions: _, insertions: _, modifications: _):
//                    self?.nodes = Array(results)
//                case .error(let error):
//                    print("Ошибка при отслеживании изменений в Realm: \(error)")
//                }
//            }
//            
//        } catch let error as NSError {
//            print("Error in get from Realm: \(error)")
//        }
//    }




//class Node: ObservableObject {
//    var name: String
//    @Published var children: [Node]
//    weak var parent: Node?
//
//    init(name: String, children: [Node] = [], parent: Node? = nil) {
//        self.name = name
//        self.children = children
//        self.parent = parent
//    }
//
//    func addChild() {
//
//        let newName = self.generateAddress()
//        let newNode = Node(name: newName)
//
//        children.append(newNode)
//        newNode.parent = self
//    }
//
//    func removeChild(node: Node) {
//        children = children.filter { $0 !== node }
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
//}
