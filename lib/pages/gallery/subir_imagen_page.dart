import 'dart:convert';
import 'dart:io';

import 'package:eventsbox/functions/functions.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SubirImagenPage extends StatefulWidget {
  final GaleriaImagenes galeria;
  const SubirImagenPage(this.galeria, {super.key});

  @override
  State<SubirImagenPage> createState() => _SubirImagenPageState();
}

class _SubirImagenPageState extends State<SubirImagenPage> {
  final TextEditingController _descriptionController =
      TextEditingController(text: '');
  File? _imagen;
  String? _base64;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _dialogFoto());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (_base64 != null) {
                  uploadImage(context, widget.galeria,
                      _descriptionController.text, _base64!);
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _imagen == null
                  ? IconButton(
                      onPressed: _dialogFoto,
                      icon: const Icon(Icons.photo_camera,
                          color: Colors.black, size: 250))
                  : Image.file(_imagen!),
            ),
            const Divider(),
            TextField(
                controller: _descriptionController,
                maxLines: null,
                maxLength: 250,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Añade una descripción...',
                    hintStyle: TextStyle(color: Colors.grey[800]))),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  /// Muestra el AlertDialog con las opciones de subir una foto desde la galería o desde la cámara
  void _dialogFoto() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                        child: const Text('Hacer una foto',
                            style: TextStyle(color: Colors.black))),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                        child: const Text('Elegir una de tus fotos',
                            style: TextStyle(color: Colors.black))),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
              ));
        });
  }

  /// Sube una foto desde la galería
  Future<void> _pickImageFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedImage = await _cropImage(image);
      File imageFile;
      croppedImage != null
          ? imageFile = File(croppedImage.path)
          : imageFile = File(image.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      _base64 = base64Encode(imageBytes);
      setState(() => _imagen = imageFile);
    }
  }

  /// Sube una foto desde la cámara
  Future<void> _pickImageFromCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      CroppedFile? croppedImage = await _cropImage(image);
      File imageFile;
      croppedImage != null
          ? imageFile = File(croppedImage.path)
          : imageFile = File(image.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      _base64 = base64Encode(imageBytes);
      setState(() => _imagen = imageFile);
    }
  }

  /// Usar ImageCropper para permitir al usuario modificar la imagen antes de subirla
  Future<CroppedFile?> _cropImage(XFile imageFile) async {
    return await ImageCropper()
        .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.grey[900],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false)
    ]);
  }
}
