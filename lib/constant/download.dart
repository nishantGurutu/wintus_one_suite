import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/controller/lead_controller.dart';

class DownloadFile {
  // Future<void> saveToDownloads(String filePath,
  //     {required bool isNetwork,
  //     required String from,
  //     int? documentId,
  //     required leadId}) async {
  //   try {
  //     Directory appDir = await getApplicationDocumentsDirectory();
  //     String appSavePath = '${appDir.path}/saved_files';

  //     Directory appSaveDir = Directory(appSavePath);
  //     if (!appSaveDir.existsSync()) {
  //       appSaveDir.createSync(recursive: true);
  //     }

  //     Directory downloadsDir = Directory('/storage/emulated/0/Download');
  //     if (!downloadsDir.existsSync()) {
  //       downloadsDir.createSync(recursive: true);
  //     }

  //     final now = DateTime.now();
  //     final fileName = "download_${now.millisecondsSinceEpoch}.jpg";

  //     final appFilePath = '$appSavePath/$fileName';
  //     final downloadFilePath = '${downloadsDir.path}/$fileName';

  //     File? savedFile;

  //     if (isNetwork) {
  //       Dio dio = Dio();
  //       await dio.download(filePath, appFilePath);
  //       await dio.download(filePath, downloadFilePath);
  //       savedFile = File(appFilePath);
  //     } else {
  //       File file = File(filePath);
  //       savedFile = await file.copy(appFilePath);
  //       await file.copy(downloadFilePath);
  //     }
  //     print('ye473 3tf7 3uy4g7 ${downloadFilePath}');
  //     // if
  //     // Get.to(()=> );
  //     final LeadController leadController = Get.put(LeadController());
  //     await leadController.updateLeadUploadedDocumentViewStatus(
  //         documentId: documentId, leadId: leadId);

  //     Fluttertoast.showToast(msg: 'File saved to Document');
  //     print('Saved in app: $appFilePath');
  //     print('Downloaded to: $downloadFilePath');
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error saving file: $e');
  //   }
  // }

  Future<void> saveToDownloads(String filePath,
      {required bool isNetwork,
      required String from,
      int? documentId,
      required leadId}) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String appSavePath = '${appDir.path}/saved_files';

      Directory appSaveDir = Directory(appSavePath);
      if (!appSaveDir.existsSync()) {
        appSaveDir.createSync(recursive: true);
      }

      Directory downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final now = DateTime.now();

      String extension = '';
      if (isNetwork) {
        Uri uri = Uri.parse(filePath);
        String path = uri.path;
        extension = path.contains('.') ? path.split('.').last : 'jpg';
      } else {
        extension = filePath.split('.').last;
      }

      final fileName = "download_${now.millisecondsSinceEpoch}.$extension";

      final appFilePath = '$appSavePath/$fileName';
      final downloadFilePath = '${downloadsDir.path}/$fileName';

      File? savedFile;

      if (isNetwork) {
        Dio dio = Dio();
        await dio.download(filePath, appFilePath);
        await dio.download(filePath, downloadFilePath);
        savedFile = File(appFilePath);
      } else {
        File file = File(filePath);
        savedFile = await file.copy(appFilePath);
        await file.copy(downloadFilePath);
      }

      print('✅ File saved to $downloadFilePath');

      final LeadController leadController = Get.put(LeadController());
      await leadController.updateLeadUploadedDocumentViewStatus(
          documentId: documentId, leadId: leadId);

      Fluttertoast.showToast(msg: 'File saved to Downloads');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving file: $e');
    }
  }
}
