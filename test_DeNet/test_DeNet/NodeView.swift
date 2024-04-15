import SwiftUI
import RealmSwift

struct NodeView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.node) { item in
                    Button {
                        self.viewModel.goNext(node: item)
                    } label: {
                        Text(item.name)
                    }
                    
                }
                .onDelete { indexSet in
                    self.viewModel.deleteNode(indexSet: indexSet)
                }
            }
        }
        .onAppear {
            print("nodeView_0")
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
//                        self.viewModel.canNavigateBack()
                        self.viewModel.goBack()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                    }
                }
            }
        }
    }
}
