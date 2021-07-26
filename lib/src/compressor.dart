import 'package:image_compression/image_compression.dart' as ic;

import 'configurations.dart';
import 'interface.dart';

ImageCompressionFlutter getCompressor() => ImageCompressionFlutterStub();

class ImageCompressionFlutterStub extends ImageCompressionFlutter {
  @override
  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param) {
    throw UnimplementedError();
  }

  @override
  Future<ic.ImageFile> compressPng(ImageFileConfiguration param) {
    throw UnimplementedError();
  }

  @override
  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param) {
    throw UnimplementedError();
  }

  @override
  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param) {
    throw UnimplementedError();
  }
}
