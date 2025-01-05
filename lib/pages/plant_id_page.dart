import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:plant_id_project/models/plant_details.dart';
import 'package:plant_id_project/models/plant_search_model.dart';
import 'package:plant_id_project/pages/details_page_dev.dart';
import 'package:plant_id_project/services/plant_search_api.dart';
import '../services/plant_id_api.dart';
import '../models/plant_identification.dart';
import '../services/plant_details_api.dart';

class PlantIdScreen extends StatefulWidget {
  const PlantIdScreen({required this.description, super.key});

  final CameraDescription description;

  @override
  State<StatefulWidget> createState() => _PlantIdScreenState();
}

class _PlantIdScreenState extends State<PlantIdScreen> {
  late CameraController controller;
  XFile? imageFile;
  Future<PlantIdentification>? plantInfo;
  bool isLoading = false;

  Future<void> takePicture() async {
    if (controller.value.isTakingPicture) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final XFile file = await controller.takePicture();
      setState(() {
        imageFile = file;
      });

      final plant = await identifyPlant(file);

      final plantSearchForToken = await searchToken(plant.plantName);

      final plantDetail = await detailPlant(plantSearchForToken.accessToken);

      setState(() {
        isLoading = false;
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsPageDev(plant: plantDetail)));
    } on CameraException catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  Future<PlantIdentification> identifyPlant(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    return await apiCall(base64Image);
    //return await apiCall(testImage);
  }

  Future<PlantSearchModel> searchToken(String name) async {
    return await plantSearchTokenApiCall(name);
  }

  Future<PlantDetails> detailPlant(String token) async {
    return await plantDetailApiCall(token);
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.description, ResolutionPreset.max);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // prompt for camera access
            break;
          default:
            // Other errors here
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Initializing...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CameraPreview(controller),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: FloatingActionButton(
                onPressed: () => takePicture(),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.green.shade100,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Identifying Plant..."),
                    SizedBox(height: 16),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
