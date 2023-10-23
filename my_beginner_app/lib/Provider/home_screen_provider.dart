import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Model/image_details.dart';

// ViewModel/Provider: Manages state and actions for the home screen
class HomeScreenProvider extends ChangeNotifier {
  // State variables
  File? _pickedImage;
  String _imageName = '';
  String _imageType = '';
  int _imageSize = 0;

  // Getters for state variables
  File? get pickedImage => _pickedImage;
  String get imageName => _imageName;
  String get imageType => _imageType;
  int get imageSize => _imageSize;

  // List to store selected images with details
  List<ImageDetails> imageList = [];

  // Method to pick an image from the gallery
  Future<void> pickImageFromGallery(BuildContext context) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      await showRenameDialog(context, File(pickedImage.path));
    }
  }

  // Method to show a dialog to rename the image
  Future<void> showRenameDialog(BuildContext context, File imageFile) async {
    String newName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(imageFile, height: 100),
              const Text('Rename Image', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'New Image Name'),
                onChanged: (value) {
                  newName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateImageDetails(imageFile, newName);
                addImageToList(); 
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  // Method to update image details and notify listeners
  void _updateImageDetails(File imageFile, String newName) {
    _pickedImage = imageFile;
    _imageName = newName;
    _imageType = imageFile.path.split('.').last;
    _imageSize = imageFile.lengthSync();
    notifyListeners();
  }

  // Method to update image name and notify listeners
  void updateImageName(String newName) {
    _imageName = newName;
    notifyListeners();
  }

  // Method to add selected image details to the list
  void addImageToList() { 
    if (_pickedImage != null && _imageName.isNotEmpty) {
      final newImageDetails = ImageDetails(
        image: _pickedImage!,
        name: _imageName,
        type: _imageType,
        size: _imageSize,
      );
      imageList.add(newImageDetails);
      notifyListeners();
    }
  }
}
