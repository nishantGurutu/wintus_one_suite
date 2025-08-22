import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/download.dart' show DownloadFile;
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/network_image_class.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class LeadOverviewDocumentListBotomsheet extends StatefulWidget {
  final dynamic leadId;
  final List<ApprovalData>? status;
  final dynamic quotationId;
  const LeadOverviewDocumentListBotomsheet(
      {super.key,
      required this.leadId,
      this.status,
      required this.quotationId});

  @override
  State<LeadOverviewDocumentListBotomsheet> createState() =>
      _LeadOverviewDocumentListBotomsheet();
}

class _LeadOverviewDocumentListBotomsheet
    extends State<LeadOverviewDocumentListBotomsheet> {
  final LeadController leadController = Get.find();

  @override
  void initState() {
    print('wjh838e3 e3uey38 4ue48 ${widget.leadId}');
    leadController.leadDocumentList(leadId: widget.leadId, from: 'initstate');
    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    leadController.documentIdList.clear();
    leadController.documentTypeListData.clear();
    leadController.isDocumentCheckBoxSelected.clear();
    leadController.documentUplodedList.clear();
    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
  }

  String _formatDate(String rawDate) {
    try {
      if (rawDate.isEmpty) return "";
      DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(rawDate);
      return DateFormat("yyyy-MM-dd hh:mm a").format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 620.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SafeArea(
          child: Obx(
            () => leadController.isDocumentListLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Document List",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                              width: 25.w,
                              height: 35.h,
                              child: SvgPicture.asset(
                                  'assets/images/svg/cancel.svg'),
                            ),
                          )
                        ],
                      ),
                      leadController.leadDocumentListData.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'No uploaded document found',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount:
                                    leadController.leadDocumentListData.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${index + 1}.",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${leadController.leadDocumentListData[index].fileName ?? ''}",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 3.h),
                                                Text(
                                                  '${_formatDate(leadController.leadDocumentListData[index].uploadedAt ?? "")}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${leadController.leadDocumentListData[index].mmIsRead ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${leadController.leadDocumentListData[index].bhIsRead ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${leadController.leadDocumentListData[index].cmoIsRead ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${leadController.leadDocumentListData[index].ceoIsRead ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  '${leadController.leadDetails.value?.approvalData?.first.branchheadStatus ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if ((StorageHelper.getRoleName()
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "null" ||
                                                  StorageHelper.getRoleName()
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "") &&
                                              leadController
                                                      .leadDetails
                                                      .value
                                                      ?.approvalData
                                                      ?.first
                                                      .managerStatus
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "pending" &&
                                              leadController
                                                      .leadDocumentListData[
                                                          index]
                                                      .status ==
                                                  0)
                                            Obx(
                                              () => leadController
                                                          .leadDocumentListData[
                                                              index]
                                                          .status ==
                                                      0
                                                  ? InkWell(
                                                      onTap: () async {
                                                        leadController
                                                                .documentIdList[
                                                            index] = leadController
                                                                .leadDocumentListData[
                                                                    index]
                                                                .id ??
                                                            0;
                                                        await takeDocument2(
                                                          index: index,
                                                          documentId: leadController
                                                                  .leadDocumentListData[
                                                                      index]
                                                                  .id ??
                                                              0,
                                                          leadId: widget.leadId,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 40.w,
                                                        height: 30.h,
                                                        child: Icon(
                                                          Icons.upload,
                                                          size: 30.sp,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ),
                                          InkWell(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return Container(
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          whiteColor,
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(width: 16),
                                                          Text(
                                                              "Downloading..."),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              await DownloadFile()
                                                  .saveToDownloads(
                                                leadController
                                                        .leadDocumentListData[
                                                            index]
                                                        .fileUrl ??
                                                    "",
                                                isNetwork: true,
                                                from: "lead_document",
                                                documentId: leadController
                                                    .leadDocumentListData[index]
                                                    .id,
                                                leadId: widget.leadId,
                                              );

                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 40.w,
                                              height: 30.h,
                                              child: Icon(
                                                Icons.download,
                                                size: 30.sp,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => leadController
                                                    .documentUplodedList[index]
                                                    .path
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                        () => ImageScreen(
                                                          file: leadController
                                                                  .documentUplodedList[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40.h,
                                                      width: 40.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                lightBorderColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.r)),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.r)),
                                                        child: Image.file(
                                                          leadController
                                                                  .documentUplodedList[
                                                              index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : leadController
                                                        .leadDocumentListData[
                                                            index]
                                                        .fileUrl
                                                        .toString()
                                                        .contains("pdf")
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Get.to(() => NetworkPDFScreen(
                                                              file: leadController
                                                                      .leadDocumentListData[
                                                                          index]
                                                                      .fileUrl ??
                                                                  ""));
                                                        },
                                                        child: Image.asset(
                                                          'assets/images/png/pdf-image-removebg-preview.png',
                                                          height: 40.h,
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          width: 40.w,
                                                          height: 40.h,
                                                          child:
                                                              NetworkImageWidget(
                                                            imageurl: leadController
                                                                .leadDocumentListData[
                                                                    index]
                                                                .fileUrl,
                                                            height: 40.h,
                                                            width: 40.w,
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                          if ((StorageHelper.getRoleName()
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "null" ||
                                                      StorageHelper
                                                                  .getRoleName()
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "") &&
                                                  leadController
                                                          .leadDetails
                                                          .value
                                                          ?.approvalData
                                                          ?.first
                                                          .managerStatus
                                                          .toString()
                                                          .toLowerCase() !=
                                                      "pending" ||
                                              StorageHelper.getRoleName()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "marketing manager" ||
                                              StorageHelper.getRoleName()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "branch head")
                                            Obx(
                                              () => Checkbox(
                                                value: leadController
                                                        .isDocumentCheckBoxSelected[
                                                    index],
                                                onChanged: (value) async {
                                                  print(
                                                      "eij893 e3ye73 ${leadController.leadDocumentListData[index].mmIsRead}");
                                                  print(
                                                      "eij893 e3ye73 2 ${leadController.leadDocumentListData[index].bhIsRead}");
                                                  print(
                                                      "eij893 e3ye73 3 ${leadController.leadDocumentListData[index].cmoIsRead}");
                                                  print(
                                                      "eij893 e3ye73 4 ${leadController.leadDocumentListData[index].ceoIsRead}");
                                                  if ((StorageHelper.getRoleName()
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "marketing manager" &&
                                                          leadController.leadDocumentListData[index].mmIsRead
                                                                  .toString() !=
                                                              "0") ||
                                                      (StorageHelper.getRoleName()
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "branch head" &&
                                                          leadController.leadDocumentListData[index].bhIsRead
                                                                  .toString() !=
                                                              "0") ||
                                                      (StorageHelper.getRoleName()
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "pa" &&
                                                          leadController
                                                                  .leadDocumentListData[
                                                                      index]
                                                                  .cmoIsRead
                                                                  .toString() !=
                                                              "0") ||
                                                      (StorageHelper.getRoleName()
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "ceo" &&
                                                          leadController
                                                                  .leadDocumentListData[index]
                                                                  .ceoIsRead
                                                                  .toString() !=
                                                              "0")) {
                                                    if ((StorageHelper.getRoleName()
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "marketing manager" &&
                                                            (leadController
                                                                        .leadDetails
                                                                        .value
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .managerStatus
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    'pending' ||
                                                                leadController
                                                                        .leadDetails
                                                                        .value
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .managerStatus
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "rejected")) ||
                                                        (StorageHelper.getRoleName()
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "branch head" &&
                                                            (leadController
                                                                        .leadDetails
                                                                        .value
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .branchheadStatus
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    'pending' ||
                                                                leadController
                                                                        .leadDetails
                                                                        .value
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .branchheadStatus
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "rejected"))) {
                                                      await leadController
                                                          .approveDocument(
                                                        documentId: leadController
                                                            .leadDocumentListData[
                                                                index]
                                                            .id,
                                                        leadId: widget.leadId,
                                                        status: leadController
                                                                    .leadDocumentListData[
                                                                        index]
                                                                    .status ==
                                                                0
                                                            ? 1
                                                            : 0,
                                                      );
                                                      leadController
                                                              .isDocumentCheckBoxSelected[
                                                          index] = value!;
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                      if ((StorageHelper.getRoleName()
                                      .toString()
                                      .toLowerCase() ==
                                  "marketing manager" &&
                              widget.status?.first.managerStatus
                                      .toString()
                                      .toLowerCase() !=
                                  'approved') ||
                          (StorageHelper.getRoleName()
                                      .toString()
                                      .toLowerCase() ==
                                  "branch head" &&
                              widget.status?.first.branchheadStatus
                                      .toString()
                                      .toLowerCase() !=
                                  'approved'))
                        Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!leadController
                                        .isDocumentCheckBoxSelected
                                        .contains(false)) {
                                      documentApprovedDialog(
                                          context, "approve");
                                    } else {
                                      CustomToast().showCustomToast(
                                          "All document not approved.");
                                    }
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      color: !leadController
                                              .isDocumentCheckBoxSelected
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
                                if (leadController.isDocumentCheckBoxSelected
                                    .contains(false))
                                  GestureDetector(
                                    onTap: () {
                                      documentApprovedDialog(
                                          context, "concern");
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
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> takeDocument2(
      {required int index, int? documentId, required leadId}) async {
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
        leadController.pickedFile2.value = file;
        await leadController.leadDocumentUpdating(
          documentId: documentId,
          ducument: leadController.pickedFile2.value,
          leadId: leadId,
        );
        print('File selected for index $index: ${file.path}');
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
                        "branch head")
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
                                        child: leadController
                                                .leadpickedFile.value
                                                .toString()
                                                .contains('pdf')
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(() => PDFScreen(
                                                      file: leadController
                                                          .leadpickedFile
                                                          .value));
                                                },
                                                child: Image.asset(
                                                  'assets/images/png/pdf-image-removebg-preview.png',
                                                  height: 40.h,
                                                ),
                                              )
                                            : Image.file(
                                                leadController
                                                    .leadpickedFile.value,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        border: Border.all(
                                                            color:
                                                                lightBorderColor)),
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
                          await leadController.approveMarketingManager(
                            leadId: widget.leadId,
                            remark: remarkControlelr.text,
                            status: type == "approve" ? 1 : 2,
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
            'selected file path from device is ${leadController.leadpickedFile.value}');
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
