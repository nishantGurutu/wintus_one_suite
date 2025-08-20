import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';

class WorkOrderDocumentApprove extends StatefulWidget {
  final dynamic documentUrl;
  final dynamic leadId;
  final dynamic legalStatus;
  final String from;
  const WorkOrderDocumentApprove(
      {super.key,
      required this.documentUrl,
      required this.leadId,
      required this.legalStatus,
      required this.from});

  @override
  State<WorkOrderDocumentApprove> createState() =>
      _WorkOrderDocumentApproveState();
}

class _WorkOrderDocumentApproveState extends State<WorkOrderDocumentApprove> {
  final LeadController leadController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF000000),
            size: 20,
          ),
        ),
        title: const Text(
          "Workorder Document",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          if (widget.legalStatus == 2 &&
              StorageHelper.getRoleName().toString().toLowerCase() ==
                  "branch head")
            GestureDetector(
              onTap: () {
                documentApprovedDialog(context, "approve");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Icon(Icons.edit),
              ),
            )
        ],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.9,
                      maxScale: 4.0,
                      child: Image.network(
                        widget.documentUrl,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              if ((StorageHelper.getRoleName().toString().toLowerCase() ==
                          "pa" &&
                      widget.from != "legal") ||
                  (StorageHelper.getRoleName().toString().toLowerCase() ==
                          "chairman" &&
                      widget.from != "ceo"))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        documentApprovedDialog(context, "approve");
                      },
                      child: Container(
                        height: 40.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: !leadController.isDocumentCheckBoxSelected
                                  .contains(false)
                              ? primaryButtonColor
                              : lightGreyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Approve',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: whiteColor),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        documentApprovedDialog(context, "concern");
                      },
                      child: Container(
                        height: 40.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Raise Concern',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController remarkControlelr = TextEditingController();
  final TextEditingController legalRemarkControlelr = TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> documentApprovedDialog(BuildContext context, String type) async {
    leadController.leadpickedFile.value = File('');
    leadController.leadWorkpickedFile.value = File('');
    leadController.leadAditionalpickedFile.value = File('');
    legalRemarkControlelr.clear();
    remarkControlelr.clear();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type == "approve"
                              ? "Approve Document"
                              : "Raise Concern",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () async {
                            Get.back();
                          },
                          child: Icon(Icons.close, size: 30),
                        ),
                      ],
                    ),
                    if (StorageHelper.getRoleName().toString().toLowerCase() ==
                            "branch head" ||
                        StorageHelper.getRoleName().toString().toLowerCase() ==
                            "chairman")
                      Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Remarks",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                width: 100.w,
                                child: Text(
                                  'Upload Document',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TaskCustomTextField(
                                  controller: remarkControlelr,
                                  focusedIndexNotifier: focusedIndexNotifier,
                                  index: 1,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  hintText: "Enter remarks",
                                  data: "",
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              InkWell(
                                onTap: () {
                                  takeDocument(from: 'upload');
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Obx(
                                    () {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.file(
                                          leadController.leadpickedFile.value,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  border: Border.all(
                                                      color: lightBorderColor)),
                                              height: 40.h,
                                              width: 100.w,
                                              child: Image.asset(
                                                'assets/image/png/Upload-Icon-Image-Background-PNG-Image.png',
                                                height: 15.h,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (StorageHelper.getRoleName().toString().toLowerCase() ==
                        "pa")
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Legal Remarks",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Upload Document',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          TaskCustomTextField(
                            controller: legalRemarkControlelr,
                            focusedIndexNotifier: focusedIndexNotifier,
                            index: 1,
                            textCapitalization: TextCapitalization.sentences,
                            hintText: "Enter legal remarks",
                            data: "",
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Work Order",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Aditional Document',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    takeDocument(from: "workorder");
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Obx(
                                      () {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.file(
                                            leadController
                                                .leadWorkpickedFile.value,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    border: Border.all(
                                                        color:
                                                            lightBorderColor)),
                                                height: 40.h,
                                                width: 100.w,
                                                child: leadController
                                                        .leadWorkpickedFile
                                                        .value
                                                        .toString()
                                                        .contains('.pdf')
                                                    ? Image.asset(
                                                        'assets/image/png/pdf.png')
                                                    : Image.asset(
                                                        'assets/image/png/Upload-Icon-Image-Background-PNG-Image.png',
                                                        height: 15.h,
                                                      ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    takeDocument(from: "aditional");
                                  },
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Obx(
                                      () {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.file(
                                            leadController
                                                .leadAditionalpickedFile.value,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    border: Border.all(
                                                        color:
                                                            lightBorderColor)),
                                                height: 40.h,
                                                width: 100.w,
                                                child: leadController
                                                        .leadAditionalpickedFile
                                                        .value
                                                        .toString()
                                                        .contains('.pdf')
                                                    ? Image.asset(
                                                        'assets/image/png/pdf.png')
                                                    : Image.asset(
                                                        'assets/image/png/Upload-Icon-Image-Background-PNG-Image.png',
                                                        height: 15.h,
                                                      ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (StorageHelper.getRoleName().toString().toLowerCase() ==
                        "marketing manager")
                      TaskCustomTextField(
                        controller: remarkControlelr,
                        focusedIndexNotifier: focusedIndexNotifier,
                        index: 1,
                        textCapitalization: TextCapitalization.sentences,
                        hintText: "Enter remarks",
                        data: "",
                      ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () async {
                        debugPrint("Approve Button Clicked");

                        if (StorageHelper.getRoleName()
                                .toString()
                                .toLowerCase() ==
                            "marketing manager") {
                        } else if (StorageHelper.getRoleName()
                                .toString()
                                .toLowerCase() ==
                            "chairman") {
                          await leadController.ceoApproving(
                            leadId: widget.leadId,
                            remark: remarkControlelr.text,
                            status: type == "approve" ? 1 : 2,
                            attachment: leadController.leadpickedFile.value,
                          );
                        } else {
                          await leadController.branchheadManagerApproving(
                            leadId: widget.leadId,
                            remark: remarkControlelr.text,
                            status: type == "approve" ? 1 : 2,
                            attachment: leadController.leadpickedFile.value,
                            workAttachment:
                                leadController.leadWorkpickedFile.value,
                            aditional:
                                leadController.leadAditionalpickedFile.value,
                            legalRemark: legalRemarkControlelr.text,
                            legalStatus: type == "approve" ? 1 : 2,
                          );
                        }
                      },
                      child: Container(
                        width: 130.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: primaryButtonColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type == 'approve' ? 'Approve' : "Concern",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> takeDocument({required String from}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        if (from == 'upload') {
          leadController.leadpickedFile.value = File(file.path);
        } else if (from == 'workorder') {
          leadController.leadWorkpickedFile.value = File(file.path);
        } else if (from == "aditional") {
          leadController.leadAditionalpickedFile.value = File(file.path);
        }
        leadController.profilePicPath.value = file.path.toString();
        // leadController.documentIdList.add();
        // leadController.documentUplodedList
        //     .add(leadController.leadpickedFile.value);
        print(
            'selected file path from device is ${leadController.leadAditionalpickedFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }
}
