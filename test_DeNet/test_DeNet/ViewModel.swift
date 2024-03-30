import Foundation

class Node: ObservableObject {
    var name: String
    @Published var children: [Node]
    weak var parent: Node?
    
    init(name: String, children: [Node] = [], parent: Node? = nil) {
        self.name = name
        self.children = children
        self.parent = parent
    }
    
    func addChild() {
        
        let newName = self.generateAddress()
        let newNode = Node(name: newName)
        
        children.append(newNode)
        newNode.parent = self
    }
    
    func removeChild(node: Node) {
        children = children.filter { $0 !== node }
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
