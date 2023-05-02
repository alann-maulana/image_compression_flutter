import 'package:image_compression/image_compression.dart' as ic;

/// The image output type
enum ImageOutputType {
  /// Export as WEBP format if possible, JPG otherwise
  webpThenJpg,

  /// Export as WEBP format if possible, PNG otherwise
  webpThenPng,

  /// Export as PNG format
  png,

  /// Export as JPG format
  jpg
}

/// The configuration options for compressing image
class Configuration {
  /// The image compression quality
  final int quality;

  /// The [ImageOutputType] of image file
  final ImageOutputType outputType;

  /// True if using native platform compressor for JPG or PNG
  final bool useJpgPngNativeCompressor;

  const Configuration({
    this.quality = 80,
    this.outputType = ImageOutputType.webpThenJpg,
    this.useJpgPngNativeCompressor = false,
  }) : assert(quality > 0 && quality <= 100);
}

/// The wrapper object for [ImageFile] and [Configuration]
class ImageFileConfiguration {
  ImageFileConfiguration({
    required this.input,
    this.config = const Configuration(),
  });

  /// The input of image file
  final ic.ImageFile input;

  /// The configuration options for compressing image
  final Configuration config;
}
