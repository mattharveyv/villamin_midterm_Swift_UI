import SwiftUI

struct AdminCategoriesView: View {
    @EnvironmentObject var store: ShopStore
    @State private var newName = ""
    @State private var showEdit: ShopStore.Category? = nil

    var body: some View {
        NavigationStack {
            List {
                Section(header:
                    HStack {
                        TextField("New Category", text: $newName)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addCategory) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.vertical, 4)
                ) {
                    ForEach(store.categories) { category in
                        HStack {
                            Text(category.name)
                            Spacer()
                            Button("Edit") {
                                showEdit = category
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .onDelete(perform: delete)
                }

                if store.categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "tag", description: Text("Add categories using the field above."))
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Categories")
            .sheet(item: $showEdit) { category in
                EditCategoryView(category: category)
                    .environmentObject(store)
            }
        }
    }

    private func addCategory() {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        store.addCategory(name: trimmed)
        newName = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            store.deleteCategory(store.categories[index])
        }
    }
}

struct EditCategoryView: View {
    @EnvironmentObject var store: ShopStore
    @Environment(\.dismiss) var dismiss
    let category: ShopStore.Category
    @State private var name: String

    init(category: ShopStore.Category) {
        self.category = category
        _name = State(initialValue: category.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Edit Category") {
                    TextField("Name", text: $name)
                }
                Section {
                    Button("Save") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            store.updateCategory(category: category, newName: trimmed)
                            dismiss()
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Edit Category")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
