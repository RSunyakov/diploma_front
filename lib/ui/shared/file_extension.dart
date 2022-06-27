enum FileExtension {
  unknown,
  jpeg,
  png,
}

class FilePathExtensions {
  static bool isPng(String filePath) => filePath.toLowerCase().endsWith('.png');

  static bool isJpeg(String filePath) =>
      filePath.toLowerCase().endsWith('.jpeg') ||
      filePath.toLowerCase().endsWith('.jpg');

  static FileExtension getExtension(String filePath) => isPng(filePath)
      ? FileExtension.png
      : isJpeg(filePath)
          ? FileExtension.jpeg
          : FileExtension.unknown;
}
