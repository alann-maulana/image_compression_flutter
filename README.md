# Flutter Image Compression

Flutter image compression and resize for Mobile, Desktop and Web. Support format JPG, PNG, WEBP.

Combining use of packages :
* [image_compression](https://pub.dev/packages/image_compression) : `MacOS`, `Windows`, `Linux` and `Web`
* [flutter_image_compress](https://pub.dev/packages/flutter_image_compress) : `Android` and `iOS`

## Compressing Image

```dart
ImageFile input; // set the input image file
Configuration config = Configuration(
   outputType: ImageOutputType.webpThenJpg,
   // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
   useJpgPngNativeCompressor: false,
   // set quality between 0-100
   quality: 40,
);

final param = ImageFileConfiguration(input: input, config: config);
final output = await compressor.compress(param);

print("Input size : ${input.sizeInBytes}");
print("Output size : ${output.sizeInBytes}");
```

