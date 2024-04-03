import SwiftUI





//struct ContentView: View {
//    
//    @State private var newNodeTitle = ""
//    
//    var body: some View {
//        NavigationStack {
//            NodeView(node: treeViewModel.rootNode, treeViewModel: treeViewModel)
//                .navigationDestination(for: Node.self) { node in
//                    NodeView(node: node, treeViewModel: treeViewModel)
//                }
//        }
//    }
//}

//struct NodeView: View {
//    @State private var newNodeTitle = ""
//    @Environment(\.presentationMode) var presentationMode
//    let node: Node
//    @ObservedObject var treeViewModel: TreeViewModel
//    
//    var body: some View {
//        VStack {
//            
//            Button("Delete") {
//                treeViewModel.deleteNode(node)
//                presentationMode.wrappedValue.dismiss()
//            }
//            
//            Spacer()
//            
//            ForEach(node.children, id: \.self) { child in
//                NavigationLink(value: child) {
//                    Text(child.title)
//                }
//            }
//        }
//        .padding()
////    }
////}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
