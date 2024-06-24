import 'dart:async';
import 'dart:io';

import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:apartment_managage/utils/logger.dart';

class FileRepositoryIml extends FileRepository {
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<void> deleteFile({required String path}) async {
    return storageRef.child(path).delete();
  }

  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    String contentType = 'image/jpeg',
    String? urlOld,
    Function(int)? onProgress,
  }) async {
    try {
      if (urlOld != null) {
        await deleteFile(path: urlOld);
      }
      final ref = storageRef.child(path);
      final uploadTask =
          ref.putFile(file, SettableMetadata(contentType: contentType));
      final snapshot = await uploadTask.whenComplete(() {});
      uploadTask.snapshotEvents.listen((TaskSnapshot event) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        final percentage = (progress * 100).toInt();
        logger.w('Uploading file image: $percentage');
        onProgress?.call(percentage);
      })
        ..onError((error) {
          logger.e(error);
          throw Exception(error.toString());
        })
        ..onDone(() {});

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
