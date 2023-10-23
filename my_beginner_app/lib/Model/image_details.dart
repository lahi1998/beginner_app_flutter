import 'dart:io';

class ImageDetails {
  final File image;     // The selected image file
  final String name;    // The name of the image
  final String type;    // The file type (extension) of the image
  final int size;       // The size of the image in bytes

  ImageDetails({
    required this.image,
    required this.name,
    required this.type,
    required this.size,
  });
}
