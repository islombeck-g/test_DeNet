import SwiftUI





struct ContentView: View {
    
    @EnvironmentObject var viewModel: V
    
    var body: some View {
        NavigationStack {
            
        }
    }
}
final class V: ObservableObject {
    
    @Published var path: NavigationPath = NavigationPath()
    
}

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
