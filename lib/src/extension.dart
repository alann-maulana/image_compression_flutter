import 'dart:typed_data';

import 'package:image_compression_flutter/image_compression_flutter.dart';

extension XFileExtension on XFile {
  Future<ImageFile> get asImageFile async {
    return ImageFile(
      filePath: path,
      rawBytes: await readAsBytes(),
      contentType: mimeType,
    );
  }
}

extension ImageFileExtension on ImageFile {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['filePath'] = filePath;
    map['rawBytes'] = List<int>.from(rawBytes);
    if (contentType != null) map['contentType'] = contentType;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;

    return map;
  }

  static ImageFile decode(dynamic data) {
    return ImageFile(
      filePath: data['filePath'],
      rawBytes: Uint8List.fromList(List<int>.from(data['rawBytes'])),
      contentType: data['contentType'],
      width: data['width'],
      height: data['height'],
    );
  }
}

extension ConfigurationExtension on Configuration {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['quality'] = quality;
    map['outputType'] = outputType.index;
    map['useJpgPngNativeCompressor'] = useJpgPngNativeCompressor;

    return map;
  }

  static Configuration decode(dynamic data) {
    return Configuration(
      quality: data['quality'] as int,
      outputType: ImageOutputType.values[data['outputType'] as int],
      useJpgPngNativeCompressor: data['useJpgPngNativeCompressor'],
    );
  }
}

extension ImageFileConfigurationExtension on ImageFileConfiguration {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['input'] = input.toMap();
    map['config'] = config.toMap();

    return map;
  }

  static ImageFileConfiguration decode(dynamic data) {
    return ImageFileConfiguration(
      input: ImageFileExtension.decode(data['input']),
      config: ConfigurationExtension.decode(data['config']),
    );
  }
}
