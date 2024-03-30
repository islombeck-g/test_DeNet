import SwiftUI
import Combine

struct NodeView: View {

    @ObservedObject var node: Node

    var body: some View {
        List {
            ForEach(node.children, id: \.name) { child in
                NavigationLink(destination: NodeView(node: child)) {
                    Text(child.name)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(node.name)
        .toolbar {
            Button {
                self.node.addChild()
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            node.removeChild(node: node.children[index])
        }
    }
}
