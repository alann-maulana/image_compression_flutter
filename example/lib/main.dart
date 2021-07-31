import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

void main() {
  runApp(MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Configuration config = Configuration();
  ImageFile? image;
  ImageFile? imageOutput;
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
        label: config.quality.toString(),
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
    final xFile = await flimer.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      final image = await xFile.asImageFile;
      setState(() {
        this.image = image;
      });
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
