import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Configuration _config = const Configuration();
  ImageFile? _image;
  ImageFile? _imageOutput;
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final buttonGallery = ElevatedButton.icon(
      onPressed: handleOpenGallery,
      icon: const Icon(Icons.photo_outlined),
      label: const Text('Pick an Image'),
    );

    final buttonCompress = Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: handleCompressImage,
        icon: const Icon(Icons.compress),
        label: const Text('Compress Image'),
      ),
    );

    Widget body = Center(child: buttonGallery);
    if (_image != null) {
      final inputImage = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.memory(_image!.rawBytes),
      );
      final inputImageSizeType = ListTile(
        title: const Text('Image size-type :'),
        subtitle: Text(
            '${(_image!.sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB - (${_image!.width} x ${_image!.height})'),
        trailing: Text(_image!.extension),
      );
      final inputImageName = ListTile(
        title: const Text('Image name :'),
        subtitle: Text(_image!.fileName),
      );

      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: buttonGallery,
            ),
            const ListTile(title: Text('INPUT IMAGE')),
            inputImage,
            inputImageSizeType,
            inputImageName,
            const Divider(),
            const ListTile(title: Text('OUTPUT IMAGE')),
            configOutputType,
            configQuality,
            nativeCompressorCheckBox,
            buttonCompress,
            _processing
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LinearProgressIndicator(),
                  )
                : const SizedBox.shrink(),
            if (_imageOutput != null && !_processing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.memory(_imageOutput!.rawBytes),
              ),
            if (_imageOutput != null && !_processing)
              ListTile(
                title: const Text('Image size-type :'),
                subtitle: Text(
                    '${(_imageOutput!.sizeInBytes / 1024 / 1024).toStringAsFixed(2)} MB - (${_imageOutput!.width} x ${_imageOutput!.height})'),
                trailing: Text(_imageOutput!.contentType ?? '-'),
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
      title: const Text('Native compressor for JPG/PNG'),
      value: _config.useJpgPngNativeCompressor,
      onChanged: (flag) {
        setState(() {
          _config = Configuration(
            outputType: _config.outputType,
            useJpgPngNativeCompressor: flag ?? false,
            quality: _config.quality,
          );
        });
      },
    );
  }

  Widget get configOutputType {
    return ListTile(
      title: const Text('Select output type'),
      subtitle: Text(_config.outputType.toString()),
      trailing: PopupMenuButton<ImageOutputType>(
        itemBuilder: (context) {
          return ImageOutputType.values
              .map((e) => PopupMenuItem(
                    value: e,
                    child: Text(e.toString()),
                  ))
              .toList();
        },
        onSelected: (outputType) {
          setState(() {
            _config = Configuration(
              outputType: outputType,
              useJpgPngNativeCompressor: _config.useJpgPngNativeCompressor,
              quality: _config.quality,
            );
          });
        },
      ),
    );
  }

  Widget get configQuality {
    return ListTile(
      title: Text('Select quality (${_config.quality})'),
      subtitle: Slider.adaptive(
        value: _config.quality.toDouble(),
        divisions: 100,
        min: 0,
        max: 100,
        label: _config.quality.toString(),
        onChanged: (value) {
          setState(() {
            _config = Configuration(
              outputType: _config.outputType,
              useJpgPngNativeCompressor: _config.useJpgPngNativeCompressor,
              quality: value.toInt(),
            );
          });
        },
      ),
    );
  }

  handleOpenGallery() async {
    final xFile = await flimer.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      final image = await xFile.asImageFile;
      setState(() {
        _image = image;
      });
    }
  }

  handleCompressImage() async {
    setState(() {
      _processing = true;
    });
    final param = ImageFileConfiguration(input: _image!, config: _config);
    final output = await compressor.compress(param);

    setState(() {
      _imageOutput = output;
      _processing = false;
    });
  }
}
