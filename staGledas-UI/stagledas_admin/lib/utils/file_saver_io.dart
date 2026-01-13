import 'dart:io';
import 'dart:typed_data';

Future<void> saveFile(Uint8List bytes, String fileName) async {
  if (bytes.isEmpty) {
    throw Exception('PDF bytes are empty');
  }

  final userProfile = Platform.environment['USERPROFILE'] ?? '';
  final downloadsPath = '$userProfile\\Downloads\\$fileName';
  final file = File(downloadsPath);
  await file.writeAsBytes(bytes);

  if (!await file.exists()) {
    throw Exception('File was not created');
  }
}
