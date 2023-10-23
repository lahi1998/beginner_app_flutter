import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/image_details.dart';
import '../Provider/home_screen_provider.dart';

// HomeScreen widget to display the app's main UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Demo'),
        ),
        body: const HomeScreenView(), // Display the HomeScreenView
      ),
    );
  }
}

// HomeScreenView widget to display the content of the home screen
class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>(); // Access provider

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              await provider.pickImageFromGallery(context); // Pick image action
            },
            child: const Text(
              "Pick Image from Gallery",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (provider.imageList.isNotEmpty) ...[
            const SizedBox(height: 10, width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Size')),
                  ],
                  rows: provider.imageList.map((imageDetails) {
                    return DataRow(
                      onSelectChanged: (isSelected) {
                        if (isSelected!) {
                          _showImageDetailsDialog(context, imageDetails);
                        }
                      },
                      cells: [
                        DataCell(Image.file(imageDetails.image, height: 50)),
                        DataCell(Text(imageDetails.name)),
                        DataCell(Text(imageDetails.type)),
                        DataCell(Text('${imageDetails.size} bytes')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Show a dialog with image details
  Future<void> _showImageDetailsDialog(
      BuildContext context, ImageDetails imageDetails) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _showOriginalImageDialog(context, imageDetails);
                },
                child: Image.file(imageDetails.image, height: 200),
              ),
              const SizedBox(height: 10),
              Text('Image Name: ${imageDetails.name}'),
              Text('Image Type: ${imageDetails.type}'),
              Text('Image Size: ${imageDetails.size} bytes'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show a dialog with the original image
  Future<void> _showOriginalImageDialog(
      BuildContext context, ImageDetails imageDetails) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(imageDetails.image),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
