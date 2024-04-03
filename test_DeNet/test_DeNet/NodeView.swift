import SwiftUI
import RealmSwift

struct NodeView: View {
    @EnvironmentObject var viewMode: ViewModel

    var body: some View {
        VStack {
            List {
                ForEach(self.treeViewModel.nodes) { item in
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
                        self.viewModel.createChildren()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            if self.viewModel.selectedNode != nil && self.viewModel.selectedNode!.parentID != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.viewModel.canNavigateBack()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.updateLast()
        }
    }
}
