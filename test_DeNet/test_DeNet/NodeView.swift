import SwiftUI

struct NodeView: View {
    
    @EnvironmentObject var viewModel: ViewModel1
    @State private var nextView: Bool = false
    @State private var backView: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.nodes) { item in
                    Button {
                        withAnimation {
                            if self.viewModel.nextPage(item: item.id) {
                                self.nextView = true
                            }
                        }
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete { indexSet in
                    self.viewModel.deleteNode(indexSet: indexSet)
                }
            }
        }
        .navigationDestination(isPresented: $nextView) {
            NodeView()
        }
        .navigationDestination(isPresented: $backView) {
            NodeView()
        }
        .navigationTitle(self.viewModel.selectedNode!.name)
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
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if self.viewModel.navigateBack() {
                        self.backView = true
                    }
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
