import SwiftUI

struct NodeView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(selectedNode: Node? = nil) {
            _viewModel = ObservedObject(wrappedValue: ViewModel(selectedNode: selectedNode))
        }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.nodes) { item in
                    
                    NavigationLink {
                        NodeView(selectedNode: item)
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete { indexSet in
                    self.viewModel.deleteNode(at: indexSet)
                }
            }
            .navigationTitle(self.viewModel.selectedNode?.name ?? "Root")
            .toolbar {
                Button {
                    self.viewModel.addChild()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
       
    }
}


//struct NodeView: View {
//
//    @ObservedObject var node: Node
//
//    var body: some View {
//        List {
//            ForEach(node.children, id: \.name) { child in
//                NavigationLink(destination: NodeView(node: child)) {
//                    Text(child.name)
//                }
//            }
//            .onDelete(perform: delete)
//        }
//        .navigationTitle(node.name)
//        .toolbar {
//            Button {
//                self.node.addChild()
//            } label: {
//                Image(systemName: "plus")
//            }
//        }
//    }
//
//    private func delete(at offsets: IndexSet) {
//        for index in offsets {
//            node.removeChild(node: node.children[index])
//        }
//    }
//}
