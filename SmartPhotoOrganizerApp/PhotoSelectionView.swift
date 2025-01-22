import SwiftUI
import Photos

struct PhotoSelectionView: View {
    @State private var photos: [PHAsset] = []
    @State private var selectedPhotos: [PHAsset] = []
    @State private var showCollageView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Select Photos for Collage")
                    .font(.largeTitle)
                    .padding()

                // Scrollable view for displaying photos
                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible()), count: 3)
                    LazyVGrid(columns: columns) {
                        ForEach(photos, id: \.self) { asset in
                            PhotoCellCollage(asset: asset, onSelect: {
                                toggleSelection(for: asset)
                            }, selected: selectedPhotos.contains(asset)) // Pass selection state
                            .frame(height: 100)
                        }
                    }
                    .padding()
                }

                Button(action: {
                    showCollageView.toggle()
                }) {
                    Text("Create Collage")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(selectedPhotos.count == 0) // Disable if no photos selected
                .padding()
            }
            .navigationTitle("Select Photos")
            .onAppear {
                loadPhotos()
            }
            .fullScreenCover(isPresented: $showCollageView) {
                CollageView(selectedPhotos: selectedPhotos) // Show collage view
            }
        }
    }

    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        var fetchedPhotos: [PHAsset] = []
        assets.enumerateObjects { (asset, _, _) in
            fetchedPhotos.append(asset)
            print("Fetched photo: \(asset.localIdentifier)")
        }

        photos = fetchedPhotos
        print("Total photos loaded: \(photos.count)")
    }

    private func toggleSelection(for asset: PHAsset) {
        if let index = selectedPhotos.firstIndex(of: asset) {
            selectedPhotos.remove(at: index) // Deselect if already selected
            print("Deselected photo: \(asset.localIdentifier)")
        } else {
            if selectedPhotos.count < 5 {
                selectedPhotos.append(asset) // Select if not already selected
                print("Selected photo: \(asset.localIdentifier)")
            } else {
                print("Maximum selection reached. Cannot select more than 5 photos.")
            }
        }
    }
}
