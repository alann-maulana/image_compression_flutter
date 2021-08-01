import 'dart:async';

import 'package:image_compression/image_compression.dart' as ic;

import 'configurations.dart';
import 'dart_compressor.dart';
import 'interface.dart';

ImageCompressionFlutter getCompressor() => ImageCompressionFlutterHtml();

class ImageCompressionFlutterHtml extends ImageCompressionFlutter {
  @override
  Future<ic.ImageFile> compressWebpThenJpg(ImageFileConfiguration param) async {
    return await DartCompressor.compressJpgDart(param);
  }

  @override
  Future<ic.ImageFile> compressWebpThenPng(ImageFileConfiguration param) async {
    return await DartCompressor.compressJpgDart(param);
  }

  @override
  Future<ic.ImageFile> compressJpg(ImageFileConfiguration param) async {
    return await DartCompressor.compressJpgDart(param);
  }

  @override
  Future<ic.ImageFile> compressPng(ImageFileConfiguration param) async {
    return await DartCompressor.compressPngDart(param);
  }
}
