import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/custom_text_convert.dart';
import 'package:task_management/custom_widget/network_image_class.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/model/lead_visit_list_model.dart';
import 'package:task_management/view/screen/lead_note.dart';
import 'package:task_management/view/screen/quotation_list.dart';
import 'package:task_management/view/widgets/add_assign_user.dart';
import 'package:task_management/view/widgets/add_lead_contact.dart';
import 'package:task_management/view/widgets/assign_user.dart';
import 'package:task_management/view/widgets/customAudioPlayer.dart';
import 'package:task_management/view/widgets/followup_list.dart';
import 'package:task_management/view/widgets/lead_discussion_list.dart';
import 'package:task_management/view/widgets/lead_document_pdf_view.dart';
import 'package:task_management/view/widgets/lead_document_remark.dart';
import 'package:task_management/view/widgets/lead_overview_document_list.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/work_order_document_approve.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'meeting/get_meeting.dart';

class LeadOverviewScreen extends StatefulWidget {
  final dynamic leadId;
  final int? index;
  final String? leadNumber;
  const LeadOverviewScreen({
    super.key,
    required this.leadId,
    this.index,
    this.leadNumber,
  });

  @override
  State<LeadOverviewScreen> createState() => _LeadOverviewScreenState();
}

class _LeadOverviewScreenState extends State<LeadOverviewScreen>
    with TickerProviderStateMixin {
  List<String> priorityList = ['High', "Low"].obs;
  RxString selectedPriority = 'High'.obs;
  final LeadController leadController = Get.put(LeadController());
  late TabController _tabController;

  Future onrefresher() async {
    await leadController.leadDetailsApi(
        leadId: int.parse(widget.leadId.toString()));
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: widget.index ?? 0);
    callingApi();
    super.initState();
  }


var isLoading = false.obs;
  void callingApi() async {
    isLoading.value = true;
    print('leadoverview lead id ${widget.leadId}');
    print('leadoverview lead id ${widget.leadNumber}');
    await leadController.leadContactList(
        leadId: int.parse(widget.leadId.toString()));
    await leadController.leadDetailsApi(
        leadId: int.parse(widget.leadId.toString()));
    await leadController.followUpsListApi(
        leadId: int.parse(widget.leadId.toString()));
isLoading.value = true;
    await SosPusherConfig()
        .initPusher(_onPusherEvent, channelName: "lead", context: context);
  }

  Future<void> _onPusherEvent(PusherEvent event) async {
    log("Pusher lead discussion event received: ${event.eventName} - ${event.data}");
  }

  @override
  void dispose() {
    leadController.leadDetails.value?.approvalData?.clear();
    SosPusherConfig().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
          "Leads Overview",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(
          () => isLoading.value== true && leadController.isLeadDetailsLoading.value == true &&
                  leadController.isFollowupsListLoading.value == true &&
                  leadController.isListVisitLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      color: whiteColor,
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/assignment_late.svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Overview',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/assignment_late.svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Followups',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/done_all (1).svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Quotation',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/done_all (1).svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Discussion',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/done_all (1).svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/image/svg/done_all (1).svg'),
                                SizedBox(width: 5.w),
                                Text(
                                  'Visits/meeting',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          leadOverview(leadController.leadDetails.value),
                          FollowUpList(
                            leadController.followUpsListData,
                            leadController.leadDetails.value,
                            widget.leadId,
                            leadController,
                          ),
                          QuotationListScreen(
                            leadId: widget.leadId,
                            leadNumber: widget.leadNumber,
                            from: "overview",
                            leadDetails: leadController.leadDetails,
                          ),
                          LeadDiscussionList(leadId: widget.leadId),
                          LeadNoteScreen(
                            leadId: widget.leadId,
                            index: 0,
                          ),
                          Obx(
                            () => GetMeetingList(
                              leadId: widget.leadId,
                              contactList: leadController.leadContactData,
                              from: "lead",
                              assignPeople: leadController
                                      .leadDetails.value?.assignedToUsers ??
                                  [],
                              addPeople: leadController
                                      .leadDetails.value?.addedUsers ??
                                  [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget leadOverview(LeadDetailsData? leadDatavalue) {
    return RefreshIndicator(
      onRefresh: onrefresher,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF5F7FF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${leadDatavalue?.leadName ?? ""}',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 16.sp,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '${leadDatavalue?.company ?? ""}',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16.sp,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '${leadDatavalue?.phone ?? ""}',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16.sp,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Expanded(
                                  child: Text(
                                    '${leadDatavalue?.email ?? ""}',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 65.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xff725CDE),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.h),
                                    child: Center(
                                      child: Text(
                                        '${leadDatavalue?.statusName ?? ""}',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Text(
                            leadDatavalue?.createdAt != null
                                ? DateFormat('dd MMM yyyy').format(
                                    DateTime.parse(leadDatavalue!.createdAt!))
                                : "",
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w400),
                          )),
                          GestureDetector(
                            onTap: () async {
                              await callWhatsApp(
                                  mobileNo: leadDatavalue?.phone);
                            },
                            child: Image.asset(
                              'assets/image/png/whatsapp (2).png',
                              height: 20.h,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () async {
                              Uri phoneno =
                                  Uri.parse('tel:${leadDatavalue?.phone}');
                              if (await launchUrl(phoneno)) {
                              } else {
                                print('Not working');
                              }
                            },
                            child: Image.asset(
                              'assets/image/png/phone_call-removebg-preview.png',
                              height: 20.h,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              leadInfo(leadDatavalue),
              SizedBox(height: 15.h),
              if ((leadDatavalue?.approvalData ?? []).isNotEmpty)
                agrementWidget(leadDatavalue),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget agrementWidget(LeadDetailsData? leadDatavalue) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Document Approval Workflow",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: LeadOverviewDocumentListBotomsheet(
                          leadId: widget.leadId,
                          status: leadDatavalue?.approvalData,
                          quotationId:
                              leadDatavalue?.approvalData?.first.quotationId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      color: primaryButtonColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    ),
                    child: Center(
                      child: Text(
                        'View Document',
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
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ShowDialogFunction().storeLeadRemark(
                      context,
                      leadDatavalue?.approvalData?.first.id,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryButtonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Text(
                        'Add Remark',
                        style: TextStyle(fontSize: 14.sp, color: whiteColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: LeadDocumentRemarkList(
                          id: leadDatavalue?.approvalData?.first.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryButtonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Text(
                        'View Remark',
                        style: TextStyle(fontSize: 14.sp, color: whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            for (int i = 0; i < (leadDatavalue?.approvalData?.length ?? 0); i++)
              Column(
                children: [
                  if (leadDatavalue?.approvalData?[i].managerStatus
                          .toString()
                          .toLowerCase() ==
                      "pending")
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffE5FFF9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                          child: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              StorageHelper.getRoleName()
                                          .toString()
                                          .toLowerCase() ==
                                      'marketing manager'
                                  ? "✅ Document successfully uploaded by ${leadController.leadDetails.value?.ownerName ?? ""}, waiting for your approval."
                                  : '✅ Document successfully uploaded & wating for marketing manager approval.',
                              style: TextStyle(
                                  fontSize: 11.sp, color: Color(0xff434343)),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  if (leadDatavalue?.approvalData?[i].managerStatus
                          .toString()
                          .toLowerCase() ==
                      "approved")
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffE5FFF9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                          child: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              '✅ Marketing Manager has approved the quotation on ${leadDatavalue?.approvalData?[i].managerTime ?? ""}.',
                              style: TextStyle(
                                  fontSize: 11.sp, color: Color(0xff434343)),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  if (leadDatavalue?.approvalData?[i].managerStatus
                          .toString()
                          .toLowerCase() ==
                      "rejected")
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffFFEEEE),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                          child: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              '❗ Marketing Manager raised a concern: "${leadDatavalue?.approvalData?[i].managerRemarks ?? ""}',
                              style: TextStyle(
                                  fontSize: 11.sp, color: Color(0xff434343)),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (leadDatavalue?.approvalData?[i].managerStatus
                                      .toString()
                                      .toLowerCase() ==
                                  "approved" ||
                              leadDatavalue?.approvalData?[i].managerStatus
                                      .toString()
                                      .toLowerCase() ==
                                  "rejected")
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: leadDatavalue
                                                ?.approvalData?[i].managerStatus
                                                .toString()
                                                .toLowerCase() ==
                                            "rejected"
                                        ? Color(0xffFFEEEE)
                                        : Color(0xffF5F7FF),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Marketing Manager :",
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '  ${leadDatavalue?.approvalData?[i].managerName ?? ""}',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        leadDatavalue?.approvalData?[i]
                                                    .managerStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                "rejected"
                                            ? Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/image/svg/sd_card_alert.svg',
                                                    height: 14.h,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Concern Raised : "${leadDatavalue?.approvalData?[i].managerRemarks}"',
                                                      style: TextStyle(
                                                          color: leadDatavalue
                                                                      ?.approvalData?[
                                                                          i]
                                                                      .managerStatus
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  "rejected"
                                                              ? Color(
                                                                  0xffFF2929)
                                                              : Color(
                                                                  0xff01A901),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/image/svg/done_all (2).svg',
                                                    height: 20.h,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'Approved',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff01A901),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          '${leadDatavalue?.approvalData?[i].managerTime ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xff747474),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          'Remark : ${leadDatavalue?.approvalData?[i].managerRemarks ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xff747474),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          if (leadDatavalue?.approvalData?[i].branchheadStatus
                                      .toString()
                                      .toLowerCase() ==
                                  "approved" ||
                              leadDatavalue?.approvalData?[i].branchheadStatus
                                      .toString()
                                      .toLowerCase() ==
                                  "rejected")
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: leadDatavalue?.approvalData?[i]
                                                .branchheadStatus
                                                .toString()
                                                .toLowerCase() ==
                                            "rejected"
                                        ? Color(0xffFFEEEE)
                                        : Color(0xffF5F7FF),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Branch Head",
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '  ${leadDatavalue?.approvalData?[i].branchheadName ?? ""}',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        leadDatavalue?.approvalData?[i]
                                                    .branchheadStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                "rejected"
                                            ? Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/image/svg/sd_card_alert.svg',
                                                    height: 14.h,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Concern Raised : "${leadDatavalue?.approvalData?[i].branchheadRemarks ?? ""}"',
                                                      style: TextStyle(
                                                          color: leadDatavalue
                                                                      ?.approvalData?[
                                                                          i]
                                                                      .branchheadStatus
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  "rejected"
                                                              ? Color(
                                                                  0xffFF2929)
                                                              : Color(
                                                                  0xff01A901),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/image/svg/done_all (2).svg',
                                                    height: 20.h,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'Approved',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff01A901),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${leadDatavalue?.approvalData?[i].brancheadTime ?? ""}',
                                              style: TextStyle(
                                                  color: Color(0xff747474),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            if (leadDatavalue?.approvalData?[i]
                                                    .branchheadStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                "rejected")
                                              GestureDetector(
                                                onTap: () {
                                                  isBranchHeadViewSelected
                                                          .value =
                                                      !isBranchHeadViewSelected
                                                          .value;
                                                },
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.w,
                                                            vertical: 5.h),
                                                    child: Text(
                                                      'View',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff1B2A64),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        if (leadDatavalue?.approvalData?[i]
                                                .branchheadStatus
                                                .toString()
                                                .toLowerCase() !=
                                            "rejected")
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Remark : ${leadDatavalue?.approvalData?[i].branchheadRemarks ?? ""}',
                                                style: TextStyle(
                                                    color: Color(0xff747474),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  isBranchHeadViewSelected
                                                          .value =
                                                      !isBranchHeadViewSelected
                                                          .value;
                                                },
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.w,
                                                            vertical: 5.h),
                                                    child: Text(
                                                      'View',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff1B2A64),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (isBranchHeadViewSelected.value ==
                                            true)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Attachment',
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Container(
                                                height: 80.h,
                                                width: 150.w,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: lightBorderColor,
                                                  ),
                                                ),
                                                child: (leadDatavalue
                                                            ?.approvalData
                                                            ?.first
                                                            .branchheadAgreement !=
                                                        null)
                                                    ? ((leadDatavalue
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .branchheadAgreement ??
                                                                    "")
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.png') ||
                                                            (leadDatavalue
                                                                        ?.approvalData
                                                                        ?.first
                                                                        .branchheadAgreement ??
                                                                    "")
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.jpg') ||
                                                            (leadDatavalue?.approvalData!.first.branchheadAgreement ?? '')
                                                                .toString()
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    '.jpeg'))
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if ((leadDatavalue
                                                                          ?.approvalData
                                                                          ?.first
                                                                          .branchheadAgreement ??
                                                                      "")
                                                                  .toString()
                                                                  .contains(
                                                                      'https')) {
                                                                Get.to(() =>
                                                                    WorkOrderDocumentApprove(
                                                                      documentUrl:
                                                                          leadDatavalue?.approvalData?.first.branchheadAgreement ??
                                                                              '',
                                                                      leadId: widget
                                                                          .leadId,
                                                                      legalStatus: leadDatavalue
                                                                          ?.approvalData?[
                                                                              i]
                                                                          .branchheadStatus,
                                                                      from:
                                                                          "branch head",
                                                                    ));
                                                              }
                                                            },
                                                            child:
                                                                Image.network(
                                                              leadDatavalue
                                                                      ?.approvalData
                                                                      ?.first
                                                                      .branchheadAgreement ??
                                                                  '',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : (leadDatavalue?.approvalData?.first.branchheadAgreement ?? "")
                                                                .toString()
                                                                .contains('pdf')
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Get.to(() =>
                                                                      WorkOrderPdfDocumentApprove(
                                                                        documentUrl: leadDatavalue
                                                                            ?.approvalData
                                                                            ?.first
                                                                            .branchheadAgreement,
                                                                        leadId:
                                                                            widget.leadId,
                                                                        legalStatus: leadDatavalue
                                                                            ?.approvalData
                                                                            ?.first
                                                                            .branchheadStatus,
                                                                        from:
                                                                            'branch head',
                                                                      ));
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/png/pdf-image-removebg-preview.png',
                                                                  height: 80.h,
                                                                ),
                                                              )
                                                            : Center(
                                                                child: InkWell(
                                                                  onTap: () {},
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .insert_drive_file,
                                                                          size:
                                                                              30),
                                                                      SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                        'No File',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.sp),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                    : Center(
                                                        child: Text('No File')),
                                              ),
                                              if (StorageHelper.getRoleName()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "pa")
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      "Click on attachment & Approve",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: textColor),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          if (leadDatavalue?.approvalData?[i].legalStatus ==
                                  1 ||
                              leadDatavalue?.approvalData?[i].legalStatus == 2)
                            Container(
                              decoration: BoxDecoration(
                                color: leadDatavalue
                                            ?.approvalData?[i].legalStatus ==
                                        1
                                    ? Color(0xffF5F7FF)
                                    : Color(0xffFFEEEE),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "IT Administrator",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '  ${leadDatavalue?.approvalData?[i].legalName ?? ""}',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    if (leadDatavalue
                                            ?.approvalData?[i].legalStatus ==
                                        1)
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/image/svg/done_all (2).svg',
                                            height: 20.h,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            'Approved',
                                            style: TextStyle(
                                                color: Color(0xff01A901),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    if (leadDatavalue
                                            ?.approvalData?[i].legalName ==
                                        2)
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/image/svg/sd_card_alert.svg',
                                            height: 14.h,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Concern Raised : "${leadDatavalue?.approvalData?[i].legalRemarks ?? ""}"',
                                              style: TextStyle(
                                                  color: Color(0xffFF2929),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      '${leadDatavalue?.approvalData?[i].legalTime ?? ""}',
                                      style: TextStyle(
                                          color: Color(0xff747474),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Remark : ${leadDatavalue?.approvalData?[i].legalRemarks ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xff747474),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            isItViewSelected.value =
                                                !isItViewSelected.value;
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6.w,
                                                  vertical: 5.h),
                                              child: Text(
                                                'View',
                                                style: TextStyle(
                                                    color: Color(0xff1B2A64),
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isItViewSelected.value == true)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Attachment',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text('Workorder')),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                  child: Text('Additional')),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(child: Text(''))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: lightBorderColor,
                                                    ),
                                                  ),
                                                  child: (leadDatavalue
                                                              ?.approvalData?[i]
                                                              .legalWorkorder !=
                                                          null)
                                                      ? ((leadDatavalue?.approvalData?[i].legalWorkorder ?? "").toLowerCase().endsWith('.png') ||
                                                              (leadDatavalue?.approvalData?[i].legalWorkorder ?? "")
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      '.jpg') ||
                                                              (leadDatavalue?.approvalData![i].legalWorkorder ?? "" ?? '')
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      '.jpeg'))
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Get.to(() => WorkOrderDocumentApprove(
                                                                    documentUrl: leadDatavalue
                                                                        ?.approvalData?[
                                                                            i]
                                                                        .legalWorkorder,
                                                                    leadId: widget
                                                                        .leadId,
                                                                    legalStatus: leadDatavalue
                                                                        ?.approvalData?[
                                                                            i]
                                                                        .legalStatus,
                                                                    from:
                                                                        "legal"));
                                                              },
                                                              child:
                                                                  Image.network(
                                                                leadDatavalue
                                                                        ?.approvalData?[
                                                                            i]
                                                                        .legalWorkorder ??
                                                                    "",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : (leadDatavalue?.approvalData![i].legalWorkorder ??
                                                                      "" ??
                                                                      '')
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      'pdf')
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(() => NetworkPDFScreen(
                                                                        file: leadDatavalue
                                                                            ?.approvalData
                                                                            ?.first
                                                                            .branchheadAgreement));
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/png/pdf-image-removebg-preview.png',
                                                                    height:
                                                                        80.h,
                                                                  ),
                                                                )
                                                              : (leadDatavalue?.approvalData![i].legalWorkorder ??
                                                                          "" ??
                                                                          '')
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .endsWith('docx')
                                                                  ? Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              5.h),
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/image/png/docs.jpeg'),
                                                                    )
                                                                  : (leadDatavalue?.approvalData![i].legalWorkorder ?? "" ?? '').toString().toLowerCase().endsWith('.jpeg')
                                                                      ? Image.asset('assets/image/png/pdf.png')
                                                                      : Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.insert_drive_file, size: 30.sp),
                                                                              SizedBox(height: 5.h),
                                                                              Text(
                                                                                'No File',
                                                                                style: TextStyle(fontSize: 12.sp),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                      : Center(
                                                          child:
                                                              Text('No File'),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: lightBorderColor,
                                                    ),
                                                  ),
                                                  child: (leadDatavalue
                                                              ?.approvalData?[i]
                                                              .legalAdditionalAttachment !=
                                                          null)
                                                      ? ((leadDatavalue
                                                                          ?.approvalData?[
                                                                              i]
                                                                          .legalAdditionalAttachment ??
                                                                      "")
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      '.png') ||
                                                              (leadDatavalue?.approvalData?[i].legalAdditionalAttachment ??
                                                                      "")
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      '.jpg') ||
                                                              (leadDatavalue
                                                                          ?.approvalData![
                                                                              i]
                                                                          .legalAdditionalAttachment ??
                                                                      "" ??
                                                                      '')
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      '.jpeg'))
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Get.to(() =>
                                                                    WorkOrderDocumentApprove(
                                                                      documentUrl:
                                                                          leadDatavalue?.approvalData?[i].legalAdditionalAttachment ??
                                                                              '',
                                                                      leadId: widget
                                                                          .leadId,
                                                                      legalStatus: leadDatavalue
                                                                          ?.approvalData?[
                                                                              i]
                                                                          .branchheadStatus,
                                                                      from:
                                                                          "legal",
                                                                    ));
                                                              },
                                                              child:
                                                                  Image.network(
                                                                leadDatavalue
                                                                        ?.approvalData?[
                                                                            i]
                                                                        .legalAdditionalAttachment ??
                                                                    "",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : (leadDatavalue?.approvalData![i].legalAdditionalAttachment ??
                                                                      "" ??
                                                                      '')
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .endsWith(
                                                                      'pdf')
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(() =>
                                                                        WorkOrderPdfDocumentApprove(
                                                                          documentUrl: leadDatavalue
                                                                              ?.approvalData![i]
                                                                              .legalAdditionalAttachment,
                                                                          leadId:
                                                                              widget.leadId,
                                                                          legalStatus: leadDatavalue
                                                                              ?.approvalData![i]
                                                                              .legalStatus,
                                                                          from:
                                                                              'legal',
                                                                        ));
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/png/pdf-image-removebg-preview.png',
                                                                    height:
                                                                        80.h,
                                                                  ),
                                                                )
                                                              : (leadDatavalue?.approvalData![i].legalAdditionalAttachment ??
                                                                          "" ??
                                                                          '')
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .endsWith(
                                                                          'docx')
                                                                  ? Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              5.h),
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/image/png/docs.jpeg'),
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.insert_drive_file,
                                                                                size: 30),
                                                                            SizedBox(height: 5),
                                                                            Text(
                                                                              'No File',
                                                                              style: TextStyle(fontSize: 12.sp),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                      : Center(
                                                          child:
                                                              Text('No File'),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (leadDatavalue?.approvalData?[i].ceoStatus.toString() ==
                          "1" ||
                      leadDatavalue?.approvalData?[i].ceoStatus.toString() ==
                          "2")
                    Container(
                      decoration: BoxDecoration(
                        color: leadDatavalue?.approvalData?[i].ceoStatus == 1
                            ? Color(0xffF5F7FF)
                            : Color(0xffFFEEEE),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "CEO",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '  ${leadDatavalue?.approvalData?[i].ceoName ?? ""}',
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            if (leadDatavalue?.approvalData?[i].ceoStatus == 1)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/image/svg/done_all (2).svg',
                                    height: 20.h,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Approved',
                                    style: TextStyle(
                                        color: Color(0xff01A901),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            if (leadDatavalue?.approvalData?[i].ceoStatus == 2)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/image/svg/sd_card_alert.svg',
                                    height: 14.h,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Concern Raised : "${leadDatavalue?.approvalData?[i].ceoRemarks ?? ""}"',
                                      style: TextStyle(
                                          color: Color(0xffFF2929),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              '${leadDatavalue?.approvalData?[i].ceoRemarksTime ?? ""}',
                              style: TextStyle(
                                  color: Color(0xff747474),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remark : ${leadDatavalue?.approvalData?[i].ceoRemarks ?? ""}',
                                  style: TextStyle(
                                      color: Color(0xff747474),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    isCeoViewSelected.value =
                                        !isCeoViewSelected.value;
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 5.h),
                                      child: Text(
                                        'View',
                                        style: TextStyle(
                                            color: Color(0xff1B2A64),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isCeoViewSelected.value == true)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attachment',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Workorder')),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(child: Text('')),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(child: Text(''))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() =>
                                                WorkOrderDocumentApprove(
                                                    documentUrl: leadDatavalue
                                                        ?.approvalData?[i]
                                                        .ceoAttachment,
                                                    leadId: widget.leadId,
                                                    legalStatus: leadDatavalue
                                                        ?.approvalData?[i]
                                                        .ceoStatus,
                                                    from: "ceo"));
                                          },
                                          child: Container(
                                            height: 80.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                            ),
                                            child: (leadDatavalue
                                                        ?.approvalData?[i]
                                                        .ceoAttachment !=
                                                    null)
                                                ? ((leadDatavalue?.approvalData?[i].ceoAttachment ?? "")
                                                            .toLowerCase()
                                                            .endsWith('.png') ||
                                                        (leadDatavalue?.approvalData?[i].ceoAttachment ?? "")
                                                            .toLowerCase()
                                                            .endsWith('.jpg') ||
                                                        (leadDatavalue?.approvalData![i].ceoAttachment ?? "" ?? '')
                                                            .toString()
                                                            .toLowerCase()
                                                            .endsWith('.jpeg'))
                                                    ? Image.network(
                                                        leadDatavalue
                                                                ?.approvalData?[
                                                                    i]
                                                                .ceoAttachment ??
                                                            "",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : (leadDatavalue?.approvalData![i].ceoAttachment ?? "" ?? '')
                                                            .toString()
                                                            .toLowerCase()
                                                            .endsWith('pdf')
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5.h),
                                                            child: Image.asset(
                                                                'assets/image/png/pdf.png'),
                                                          )
                                                        : (leadDatavalue?.approvalData![i].ceoAttachment ?? "" ?? '')
                                                                .toString()
                                                                .toLowerCase()
                                                                .endsWith(
                                                                    'docx')
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.h),
                                                                child: Image.asset(
                                                                    'assets/image/png/docs.jpeg'),
                                                              )
                                                            : (leadDatavalue?.approvalData![i].ceoAttachment ??
                                                                        "" ??
                                                                        '')
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .endsWith('.jpeg')
                                                                ? Image.asset('assets/image/png/pdf.png')
                                                                : Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .insert_drive_file,
                                                                            size:
                                                                                30.sp),
                                                                        SizedBox(
                                                                            height:
                                                                                5.h),
                                                                        Text(
                                                                          'No File',
                                                                          style:
                                                                              TextStyle(fontSize: 12.sp),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                : Center(
                                                    child: Text('No File'),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  RxBool isBranchHeadViewSelected = false.obs;
  RxBool isItViewSelected = false.obs;
  RxBool isCeoViewSelected = false.obs;

  Widget leadInfo(LeadDetailsData? leadDataValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Information',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Create Date',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        leadDataValue?.createdAt != null
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(leadDataValue!.createdAt!))
                            : "",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Source',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${leadDataValue?.sourceName ?? ""}",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Owner',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                      child: Image.asset(
                        backgroundLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${leadDataValue?.ownerName ?? ""}',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                if ((leadDataValue?.image ?? "").isNotEmpty ||
                    (leadDataValue?.audio ?? "").isNotEmpty)
                  SizedBox(height: 10.h),
                if ((leadDataValue?.image ?? "").isNotEmpty ||
                    (leadDataValue?.audio ?? "").isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NetworkImageWidget(
                          imageurl: leadDataValue?.image ?? "",
                          height: 60.h,
                          width: 80.w),
                      if ((leadDataValue?.audio ?? "").isNotEmpty)
                        CustomAudioPlayer(
                          audioUrl: leadDataValue?.audio ?? '',
                          chatId: '',
                        )
                    ],
                  ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Last Modified',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        leadDataValue?.createdAt != null
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(leadDataValue!.updatedAt!))
                            : "",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      'Added User',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if ((leadDataValue?.addedUsers?.length ?? 0) > 0)
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: LeadAddUserList(
                                    addUser: leadDataValue?.addedUsers ?? []),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Stack(
                              children: List.generate(
                                (leadDataValue?.addedUsers?.length ?? 0) > 3
                                    ? 4
                                    : (leadDataValue?.addedUsers?.length ?? 0),
                                (index) {
                                  if (index < 3) {
                                    final leftPosition = index == 0
                                        ? 0.0
                                        : (index == 1 ? 22.w : 44.w);
                                    final bgColor = index == 0
                                        ? redColor
                                        : index == 1
                                            ? blueColor
                                            : secondaryColor;

                                    return Positioned(
                                      left: leftPosition,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          child: Image.network(
                                            '${leadDataValue?.addedUsers?[index].image ?? ""}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.r)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final extraCount =
                                        (leadDataValue?.addedUsers?.length ??
                                                0) -
                                            3;
                                    return Positioned(
                                      left: 65.w,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: primaryButtonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+$extraCount',
                                            style: changeTextColor(
                                                heading9, whiteColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Text(
                      'Assigned User',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if ((leadDataValue?.assignedToUsers?.length ?? 0) > 0)
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: LeadAssignUserList(
                                    assignUser:
                                        leadDataValue?.assignedToUsers ?? []),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Stack(
                              children: List.generate(
                                (leadDataValue?.assignedToUsers?.length ?? 0) >
                                        3
                                    ? 4
                                    : (leadDataValue?.assignedToUsers?.length ??
                                        0),
                                (index) {
                                  if (index < 3) {
                                    final leftPosition = index == 0
                                        ? 0.0
                                        : (index == 1 ? 22.w : 44.w);
                                    final bgColor = index == 0
                                        ? redColor
                                        : index == 1
                                            ? blueColor
                                            : secondaryColor;

                                    return Positioned(
                                      left: leftPosition,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          child: Image.network(
                                            '${leadDataValue?.assignedToUsers?[index].image ?? ""}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.r)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final extraCount = (leadDataValue
                                                ?.assignedToUsers?.length ??
                                            0) -
                                        3;
                                    return Positioned(
                                      left: 65.w,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: primaryButtonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+$extraCount',
                                            style: changeTextColor(
                                                heading9, whiteColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddLeadContactShet(leadId: widget.leadId),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff1B2A64),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff1B2A64),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Add New',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1B2A64)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                if (leadController.leadContactData.length > 0)
                  Obx(
                    () => leadController.isLeadContactLoading.value == true
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              for (int i = 0;
                                  i < leadController.leadContactData.length;
                                  i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffF5F7FF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 8.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 33.h,
                                            width: 33.w,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFF5959),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(17.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${CustomTextConvert().getNameChar(leadController.leadContactData[i].name ?? '')}',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${leadController.leadContactData[i].name ?? ""}',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '${leadController.leadContactData[i].phone ?? ""}',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await callWhatsApp(
                                                  mobileNo: leadController
                                                      .leadContactData[i]
                                                      .phone);
                                            },
                                            child: Image.asset(
                                              'assets/image/png/whatsapp (2).png',
                                              height: 20.h,
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          GestureDetector(
                                            onTap: () async {
                                              Uri phoneno = Uri.parse(
                                                  'tel:${leadController.leadContactData[i].phone}');
                                              if (await launchUrl(phoneno)) {
                                              } else {
                                                print('Not working');
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/image/png/phone_call-removebg-preview.png',
                                              height: 20.h,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget visitList(List<ListVisitData> visitDatavalue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          SizedBox(height: 10.h),
          Expanded(
            child: visitDatavalue.isEmpty
                ? Center(
                    child: Text(
                      "No visit data",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: visitDatavalue.length,
                    itemBuilder: (context, index) {
                      final item = visitDatavalue[index];

                      String formattedDate = '';
                      if (item.createdAt != null) {
                        DateTime date = DateTime.parse(item.createdAt!);
                        formattedDate =
                            DateFormat('dd MMM yyyy, hh:mm a').format(date);
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Visitor Name & Type
                            Row(
                              children: [
                                Icon(Icons.person,
                                    size: 18.sp, color: Colors.blue),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    '${item.visitorName ?? "No Name"} (${item.visitTypeName ?? "Visit"})',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Phone and Email
                            Row(
                              children: [
                                Icon(Icons.phone,
                                    color: Colors.green, size: 18.sp),
                                SizedBox(width: 6.w),
                                Text(item.visitorPhone ?? '',
                                    style: TextStyle(fontSize: 13.sp)),
                                SizedBox(
                                  width: 35.w,
                                ),
                                Icon(Icons.email,
                                    color: Colors.orange, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.visitorEmail ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Address
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.red, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.address ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Description
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.notes,
                                    color: Colors.teal, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.description ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Visit Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18.sp, color: Colors.deepPurple),
                                SizedBox(width: 6.w),
                                Text('Visited on: $formattedDate',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic)),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await callWhatsApp(
                                        mobileNo: leadController
                                            .leadsListData[index].phone);
                                  },
                                  child: Image.asset(
                                    'assets/image/png/whatsapp (2).png',
                                    height: 20.h,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                GestureDetector(
                                  onTap: () async {
                                    Uri phoneno = Uri.parse(
                                        'tel:${leadController.leadsListData[index].phone}');
                                    if (await launchUrl(phoneno)) {
                                    } else {
                                      print('Not working');
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/image/png/phone_call-removebg-preview.png',
                                    height: 20.h,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null) return 'Invalid Date';
    try {
      final dateTime = DateTime.parse(rawDate);
      return "${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}";
    } catch (e) {
      return rawDate;
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  Future<void> callWhatsApp({String? mobileNo}) async {
    String? mobileContact =
        mobileNo!.contains('+91') ? mobileNo : "+91$mobileNo";
    var androidUrl = "whatsapp://send?phone=$mobileContact";
    var iosUrl = "https://wa.me/$mobileContact";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }
}
