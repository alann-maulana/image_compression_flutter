import 'package:cross_file/cross_file.dart';
import 'package:image_compression/image_compression.dart';

extension XFileExtension on XFile {
  Future<ImageFile> get asImageFile async {
    return ImageFile(
      filePath: path,
      rawBytes: await readAsBytes(),
      contentType: mimeType,
    );
  }
}
