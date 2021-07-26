import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_compression/image_compression.dart' as ic;
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ImagePicker _picker = ImagePicker();
  Configuration config = Configuration();
  ic.ImageFile? image;
  ic.ImageFile? imageOutput;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final buttonGallery = ElevatedButton.icon(
      onPressed: handleOpenGallery,
      icon: Icon(Icons.photo_outlined),
      label: Text('Pick an Image'),
    );

    final buttonCompress = Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: handleCompressImage,
        icon: Icon(Icons.compress),
        label: Text('Compress Image'),
      ),
    );

    Widget body = Center(child: buttonGallery);
    if (image != null) {
      final inputImage = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.memory(image!.rawBytes),
      );
      final inputImageSizeType = ListTile(
        title: Text('Image size-type :'),
        subtitle: Text(
            '${(image!.sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB - (${image!.width} x ${image!.height})'),
        trailing: Text(image!.extension),
      );
      final inputImageName = ListTile(
        title: Text('Image name :'),
        subtitle: Text(image!.fileName),
      );

      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: buttonGallery,
            ),
            ListTile(title: Text('INPUT IMAGE')),
            inputImage,
            inputImageSizeType,
            inputImageName,
            Divider(),
            ListTile(title: Text('OUTPUT IMAGE')),
            configOutputType,
            configQuality,
            nativeCompressorCheckBox,
            buttonCompress,
            processing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LinearProgressIndicator(),
                  )
                : SizedBox.shrink(),
            if (imageOutput != null && !processing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.memory(imageOutput!.rawBytes),
              ),
            if (imageOutput != null && !processing)
              ListTile(
                title: Text('Image size-type :'),
                subtitle: Text(
                    '${(imageOutput!.sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB - (${imageOutput!.width} x ${imageOutput!.height})'),
                trailing: Text(imageOutput!.contentType ?? '-'),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Compression'),
      ),
      body: body,
    );
  }

  Widget get nativeCompressorCheckBox {
    return CheckboxListTile(
      title: Text('Native compressor for JPG/PNG'),
      value: config.useJpgPngNativeCompressor,
      onChanged: (flag) {
        setState(() {
          config = Configuration(
            outputType: config.outputType,
            useJpgPngNativeCompressor: flag ?? false,
            quality: config.quality,
          );
        });
      },
    );
  }

  Widget get configOutputType {
    return ListTile(
      title: Text('Select output type'),
      subtitle: Text(config.outputType.toString()),
      trailing: PopupMenuButton<ImageOutputType>(
        itemBuilder: (context) {
          return ImageOutputType.values
              .map((e) => PopupMenuItem(
                    child: Text(e.toString()),
                    value: e,
                  ))
              .toList();
        },
        onSelected: (outputType) {
          setState(() {
            config = Configuration(
              outputType: outputType,
              useJpgPngNativeCompressor: config.useJpgPngNativeCompressor,
              quality: config.quality,
            );
          });
        },
      ),
    );
  }

  Widget get configQuality {
    return ListTile(
      title: Text('Select quality (${config.quality})'),
      subtitle: Slider.adaptive(
        value: config.quality.toDouble(),
        divisions: 100,
        min: 0,
        max: 100,
        label: 'Quality',
        onChanged: (value) {
          setState(() {
            config = Configuration(
              outputType: config.outputType,
              useJpgPngNativeCompressor: config.useJpgPngNativeCompressor,
              quality: value.toInt(),
            );
          });
        },
      ),
    );
  }

  handleOpenGallery() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          this.image = ic.ImageFile(
            filePath: image.path,
            rawBytes: bytes,
          );
        });
      }
    } on MissingPluginException catch (_) {
      final photoDir = await getDownloadsDirectory();
      final path = await FilesystemPicker.open(
        title: 'Pick an Image',
        context: context,
        rootDirectory: photoDir!,
        fsType: FilesystemType.file,
        folderIconColor: Theme.of(context).primaryColor,
        allowedExtensions: ['.jpg', '.jpeg', '.png'],
        fileTileSelectMode: FileTileSelectMode.wholeTile,
      );

      if (path != null) {
        final file = File(path);
        final bytes = await file.readAsBytes();
        setState(() {
          this.image = ic.ImageFile(
            filePath: file.path,
            rawBytes: bytes,
          );
        });
      }
    }
  }

  handleCompressImage() async {
    setState(() {
      processing = true;
    });
    final param = ImageFileConfiguration(input: image!, config: config);
    final output = await compressor.compress(param);

    setState(() {
      imageOutput = output;
      processing = false;
    });
  }
}
