import 'package:image_compression/image_compression.dart' as ic;

import 'configurations.dart';

abstract class ImageCompressionFlutter {
  Future<ic.ImageFile> compress(ImageFileConfiguration param) async {
    switch (param.config.outputType) {
      case ImageOutputType.webpThenJpg:
        return compressWebpThenJpg(param);
      case ImageOutputType.webpThenPng:
        return compressWebpThenPng(param);
      case ImageOutputType.jpg:
        return compressJpg(param);
      case ImageOutputType.png:
        return compressPng(param);
    }
  }

  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param);

  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param);

  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param);

  Future<ic.ImageFile> compressPng(ImageFileConfiguration param);
}
