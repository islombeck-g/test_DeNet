import SwiftUI
import RealmSwift

struct NodeView: View {
    
    @ObservedObject var viewModel: ViewModel
    init(selectedNodeID: ObjectId) {
        _viewModel = ObservedObject(wrappedValue: ViewModel(selectedNodeID: selectedNodeID))
    }
//    @Environment(\.dismiss) var dismiss
    
    var selectedNodeId: ObjectId?
    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.nodes) { item in
                    NavigationLink(destination: NodeView(selectedNodeID: item.id)) {
                        Text(item.name)
                    }
                }
                .onDelete { indexSet in
                    self.viewModel.deleteNode(indexSet: indexSet)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(self.viewModel.selectedNode?.name ?? "SomeError")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        self.viewModel.addChildren()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            if self.viewModel.selectedNode != nil && self.viewModel.selectedNode!.parentID != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.viewModel.canNavigateBack()
//                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                    }
                }
            }
        }
//        .onAppear {
//            self.viewModel.nextPage(item: selectedNodeId)
//        }
    }
}
//struct NodeView: View {
//    
//    @EnvironmentObject var viewModel: ViewModel
//    
//    var selectedNodeId: ObjectId?
//    var body: some View {
//        VStack {
//            List {
//                ForEach(self.viewModel.nodes) { item in
//                    NavigationLink(destination: NodeView(selectedNodeId: item.id)) {
//                        Text(item.name)
//                    }
//                }
//                .onDelete { indexSet in
//                    self.viewModel.deleteNode(indexSet: indexSet)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationTitle(self.viewModel.selectedNode?.name ?? "SomeError")
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    withAnimation {
//                        self.viewModel.addChildren()
//                    }
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//            if self.viewModel.selectedNode != nil && self.viewModel.selectedNode!.parentID != nil {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        self.viewModel.canNavigateBack()
//                    } label: {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Назад")
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            self.viewModel.nextPage(item: selectedNodeId)
//        }
//    }
//}
