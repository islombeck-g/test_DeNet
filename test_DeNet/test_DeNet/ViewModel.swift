import Foundation
import RealmSwift
import Combine

final class ViewModel: ObservableObject {
    
    @Published var selectedNodeId: ObjectId?
    @Published var selectedNode: Node?
    
    private var realm: Realm?
    
    init(selectedNode: Node? = nil) {
        guard let realm = try? Realm() else {
            fatalError("Unable to instantiate Realm")
        }
        
        self.realm = realm
        
        if let selectedNode = selectedNode {
            self.selectedNode = selectedNode
        } else if let root = realm.objects(Node.self).first {
            self.selectedNode = root
        } else {
            let root = Node()
            root.name = "Root"
            self.selectedNode = root
            try? realm.write {
                realm.add(root)
            }
        }
    }
    
    func addChild() {
        guard let selectedNode = selectedNode else { return }
        
        let newNode = Node(value: ["_id": ObjectId.generate()])
        newNode.name = generateAddress()
        
        try? realm?.write {
            selectedNode.children.append(newNode)
        }
        objectWillChange.send()
        self.selectedNode = nil
        self.selectedNode = selectedNode
    }
    
    func deleteNode(at indexSet: IndexSet) {
        if let index = indexSet.first, let realm = selectedNode?.children[index].realm {
            print(index)
            let root = selectedNode?.children[index]
            self.recursiveDelete(node: root!, realm: realm)
        }
    }
    
    private func recursiveDelete(node: Node, realm: Realm) {
        guard !node.children.isEmpty else {
            try? realm.write({
                realm.delete(node)
            })
            return
        }
        for i in node.children {
            recursiveDelete(node: i, realm: realm)
        }
        try? realm.write({
            realm.delete(node)
        })
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
}
//    func addChild () {
//        guard let selectedNode = selectedNode else { return }
//
//        let newNode = Node(value: ["_id": ObjectId.generate()])
//        newNode.name = generateAddress()
//
//        try? realm?.write({
//            selectedNode.children.append(newNode)
//        })
//        self.selectedNode?.children = self.selectedNode!.children
//    }



//final class ViewModel: ObservableObject {
//
//    @Published var nodes: List<Node>?
//    private var privateNodes: List<Node>?
//
//    @Published var selectedNode: Node? {
//        didSet {
//            self.nodes = selectedNode?.children
//            observeChildNodes()
//        }
//    }
//
//    private var realm: Realm?
//
//    init(selectedNode: Node? = nil) {
//        guard let realm = try? Realm() else {
//            fatalError("Unable to instantiate Realm")
//        }
//        self.realm = realm
//
//        if let selectedNode = selectedNode {
//            self.selectedNode = selectedNode
//            self.privateNodes = selectedNode.children
//        } else if let root = realm.objects(Node.self).first {
//            self.selectedNode = root
//            self.privateNodes = root.children
//        } else {
//            let root = Node()
//            root.name = "Root"
//            self.selectedNode = root
//            self.privateNodes = root.children
//            try? realm.write {
//                realm.add(root)
//            }
//        }
//        observeChildNodes()
//    }
//
//    private func observeChildNodes() {
//        self.privateNodes = selectedNode?.children
//    }
//
//    func deleteNode(at indexSet: IndexSet) {
//        if let index = indexSet.first, let realm = privateNodes?[index].realm {
//            let root = privateNodes?[index]
//            self.recursiveDelete(node: root!, realm: realm)
//        }
//    }
//
//    func addChild () {
//        guard let selectedNode = selectedNode else { return }
//
//        let newNode = Node()
//        newNode.name = generateAddress()
//
//        try? realm?.write({
//            selectedNode.children.append(newNode)
//        })
//        self.observeChildNodes()
//    }
//
//    private func recursiveDelete(node: Node, realm: Realm) {
//        guard !node.children.isEmpty else {
//            try? realm.write({
//                realm.delete(node)
//            })
//            return
//        }
//        for i in node.children {
//            recursiveDelete(node: i, realm: realm)
//        }
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



//final class ViewModel: ObservableObject {
//
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published var nodes: List<Node>
//    @Published var selectedNode: Node? {
//        didSet {
//            self.nodes = selectedNode?.children ?? List<Node>()
//            observeChildNodes()
//        }
//    }
//
//    private var token: NotificationToken?
//    private var realm: Realm?
//
//    init(selectedNode: Node? = nil) {
//        let realm = try? Realm()
//        self.realm = realm
//
//        if let selectedNode = selectedNode {
//            self.selectedNode = selectedNode
//            self.nodes = selectedNode.children
//        } else if let root = realm?.objects(Node.self).first {
//            self.selectedNode = root
//            self.nodes = root.children
//        } else {
//            let root = Node()
//            root.name = "Root"
//            self.selectedNode = root
//            self.nodes = root.children
//            try? realm?.write {
//                realm?.add(root)
//            }
//        }
//        observeChildNodes()
//    }
//
//    private func observeChildNodes() {
//        self.nodes = selectedNode?.children ?? List<Node>()
//    }
//
//    func deleteNode(at indexSet: IndexSet) {
//        if let index = indexSet.first, let realm = nodes[index].realm {
//            let root = nodes[index]
//            self.recursiveDelete(node: root, realm: realm)
//        }
//    }
//
//    func addChild () {
//
//        let newNode = Node()
//        newNode.name = generateAddress()
//        newNode.parent = self.selectedNode
//
//        if let realm = selectedNode?.realm {
//            try? realm.write({
//                print("i am here")
//                selectedNode?.children.append(newNode)
//            })
//            self.observeChildNodes()
//        }
//    }
//
//    private func recursiveDelete(node: Node, realm: Realm) {
//        guard !node.children.isEmpty else {
//            try? realm.write({
//                realm.delete(node)
//            })
//            return
//        }
//        for i in node.children {
//            recursiveDelete(node: i, realm: realm)
//        }
//    }
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
//
//    deinit {
//        token?.invalidate()
//    }
//}

//final class ViewModel: ObservableObject {
//
//    private var nodes = List<Node>()
//    private var cancellables = Set<AnyCancellable>()
//    private var realm: Realm?
//
//    @Published var publishedNodes = List<Node>()
//    @Published var selectedNode: Node? {
//        didSet {
//            self.updateNodes()
//        }
//    }
//
//    init(selectedNode: Node? = nil) {
//        self.realm = try? Realm()
//
//        if let selectedNode = selectedNode {
//            self.selectedNode = selectedNode
//            self.nodes = selectedNode.children
//            self.publishedNodes = self.nodes.freeze()
//        } else if let root = realm?.objects(Node.self).first {
//            self.selectedNode = root
//            self.nodes = root.children
//            self.publishedNodes = self.nodes.freeze()
//        } else {
//            let root = Node()
//            root.name = "Root"
//            try? realm?.write {
//                realm?.add(root)
//            }
//            self.selectedNode = root
//        }
//        self.updateNodes()
//    }
//
//    private func updateNodes() {
//        self.nodes = selectedNode?.children ?? List<Node>()
//        self.publishedNodes = self.nodes.freeze()
//    }
//
//    func deleteNode(at indexSet: IndexSet) {
//
//        DispatchQueue.main.async { [weak self] in
//            guard
//                let self = self,
//                let index = indexSet.first
//            else {
//                return
//            }
//
//            let root = self.nodes[index]
//            recursiveDelete(node: root)
//
//            self.updateNodes()
//        }
//    }
//    private func recursiveDelete(node: Node) {
//        guard let realm = try? Realm(), let liveNode = realm.object(ofType: Node.self, forPrimaryKey: node.id) else { return }
//
//        guard !liveNode.children.isEmpty else {
//            try? realm.write {
//                realm.delete(liveNode)
//            }
//            return
//        }
//
//        for child in liveNode.children {
//            recursiveDelete(node: child)
//        }
//    }
////    private func recursiveDelete(node: Node) {
////        guard !node.children.isEmpty else {
////            try? realm?.write({
////                realm?.delete(node)
////            })
////            return
////        }
////        for i in node.children {
////            self.recursiveDelete(node: i)
////        }
////    }
//    func addChild() {
//        // Ensure you're working with a live (unfrozen) Realm instance
//        guard let realm = try? Realm() else { return }
//
//        // If there's a chance the selectedNode is frozen, retrieve a live version using its primary key
//        guard let selectedNodeId = selectedNode?.id, let liveSelectedNode = realm.object(ofType: Node.self, forPrimaryKey: selectedNodeId) else { return }
//
//        let newNode = Node()
//        newNode.name = generateAddress()
//        newNode.parent = liveSelectedNode
//
//        do {
//            try realm.write {
//                liveSelectedNode.children.append(newNode)
//            }
//            self.updateNodes()
//        } catch let error {
//            print("Failed to add child: \(error.localizedDescription)")
//        }
//    }
////    func addChild () {
////        let newNode = Node()
////        newNode.name = generateAddress()
////        newNode.parent = selectedNode
////
////        if let realm = selectedNode?.realm {
////            try? realm.write({
////                print("i am here")
////                selectedNode?.children.append(newNode)
////            })
////            self.updateNodes()
////        }
////    }
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
//    deinit {
//        cancellables.forEach { $0.cancel() }
//    }
//}





//MARK: -

//    func deleteNode(at indexSet: IndexSet) {
//
//        DispatchQueue.main.async { [weak self] in
//            guard
//                let self = self,
//                let index = indexSet.first,
//                let realm = self.nodes[index].realm
//            else {
//                return
//            }
//
//            let root = self.nodes[index]
//            self.recursiveDelete(node: root, realm: realm)
//            print(2)
//            self.updateNodes()
//            print(3)
//        }
//    }


//    private func observeChildNodes() {
//        token?.invalidate()
//        token = selectedNode?.children.observe { [weak self] changes in
//            switch changes {
//            case .initial, .update:
//                self?.objectWillChange.send()
//            case .error(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
//final class ViewModel1: ObservableObject {
//
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published var nodes = List<Node>()
//    @Published var selectedNode: Node? = nil
//
//    var token: NotificationToken? = nil
//
//    init(selectedNode: Node? = nil) {
//        self.selectedNode = selectedNode
//        self.nodes = selectedNode?.children ?? List<Node>()
//        let realm = try? Realm()
//        if let nodes = realm?.objects(Node.self).first {
//            self.selectedNode = nodes
//            self.nodes = nodes.children
//        } else {
//            try? realm?.write({
//                let group = Node()
//                group.name = "Root"
//                group.parent = nil
//                realm?.add(group)
//                self.selectedNode = group
//            })
//
//        }
//        token = selectedNode?.children.observe({ (changes: RealmCollectionChange<List<Node>>) in
//            switch changes {
//            case .error(_):
//                break
//            case .initial:
//                break
//            case .update(_, deletions: _, insertions: _, modifications: _):
//                self.objectWillChange.send()
//            }
//        })
//    }
//
//
//
//    func deleteNode(at indexSet: IndexSet) {
//        if let index = indexSet.first, let realm = nodes[index].realm {
//            try? realm.write({
//                realm.delete(nodes[index])
//            })
//        }
//    }
//
//
//
//    func addChild () {
//
//        let newNode = Node()
//        newNode.name = generateAddress()
//        newNode.parent = self.selectedNode
//
//        if let realm = selectedNode?.realm {
//            try? realm.write({
//                print("i am here")
//                selectedNode?.children.append(newNode)
//            })
//        }
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
//
//    deinit {
//        token?.invalidate()
//    }
//}

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
