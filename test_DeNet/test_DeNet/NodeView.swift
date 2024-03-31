import SwiftUI

struct NodeView: View {
    @ObservedObject var viewModel: ViewModel
    init(selectedNode: Node? = nil) {
        _viewModel = ObservedObject(wrappedValue: ViewModel(selectedNode: selectedNode))
    }
    
    var body: some View {
        VStack {
            List {
                if let res = self.viewModel.nodes {
                    ForEach(res) { item in
                        
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

//
//var hoges: Results<Hoge>?
//@Published var freezedHoges: Results<Hoge>?
//
//let realm = try! Realm()
//  
//init() {
//  hoges = realm.objects(Hoge.self)
//  freezedHoges = hoges?.freeze()
//}
//
//func addHoge() {
//  let hoge = Hoge()
//  hoge.id = NSUUID().uuidString
//  hoge.title = "fuga"
//  try! realm.write {
//    realm.add(hoge)
//  }
//  freezedHoges = hoges?.freeze()
//}
