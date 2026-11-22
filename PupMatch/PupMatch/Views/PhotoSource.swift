//
//  PhotoSource.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import SwiftUI
import PhotosUI
import UIKit

// UIKit camera wrapped for SwiftUI
struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    var onCapture: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage { parent.onCapture(image) }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// attach with .photoSource(isPresented:) on any view; it offers camera and library
struct PhotoSourceModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onPick: (UIImage) -> Void

    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var libraryItem: PhotosPickerItem?

    func body(content: Content) -> some View {
        content
            .confirmationDialog("Add a photo", isPresented: $isPresented, titleVisibility: .visible) {
                // the simulator has no camera, so only offer it where it exists
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("Take Photo") { showCamera = true }
                }
                Button("Choose from Library") { showLibrary = true }
                Button("Cancel", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker(onCapture: onPick).ignoresSafeArea()
            }
            .photosPicker(isPresented: $showLibrary, selection: $libraryItem, matching: .images)
            .onChange(of: libraryItem) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) { onPick(image) }
                    libraryItem = nil    // reset so the same photo can be picked twice
                }
            }
    }
}

extension View {
    func photoSource(isPresented: Binding<Bool>, onPick: @escaping (UIImage) -> Void) -> some View {
        modifier(PhotoSourceModifier(isPresented: isPresented, onPick: onPick))
    }
}
