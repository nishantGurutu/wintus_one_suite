class LeedListModel {
  bool? status;
  String? message;
  List<LeadListData>? data;
  Pagination? pagination;

  LeedListModel({this.status, this.message, this.data, this.pagination});

  LeedListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeadListData>[];
      json['data'].forEach((v) {
        data!.add(new LeadListData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class LeadListData {
  int? id;
  dynamic leadNumber;
  dynamic userId;
  dynamic leadName;
  dynamic leadType;
  dynamic company;
  dynamic phone;
  dynamic email;
  dynamic source;
  dynamic designation;
  dynamic gender;
  dynamic status;
  dynamic noOfProject;
  dynamic description;
  dynamic regionalOfc;
  dynamic referenceDetails;
  dynamic image;
  dynamic audio;
  dynamic type;
  dynamic addressType;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic cityTown;
  dynamic postalCode;
  dynamic sectorLocality;
  dynamic country;
  dynamic state;
  dynamic visitingCard;
  dynamic latitude;
  dynamic longitude;
  dynamic peopleAdded;
  dynamic assignedTo;
  dynamic isDeleted;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic sourceName;
  dynamic statusName;
  dynamic ownerName;
  dynamic documentUploadStatus;
  List<ApprovalData>? approvalData;

  LeadListData(
      {this.id,
      this.leadNumber,
      this.userId,
      this.leadName,
      this.leadType,
      this.company,
      this.phone,
      this.email,
      this.source,
      this.designation,
      this.gender,
      this.status,
      this.noOfProject,
      this.description,
      this.regionalOfc,
      this.referenceDetails,
      this.image,
      this.audio,
      this.type,
      this.addressType,
      this.addressLine1,
      this.addressLine2,
      this.cityTown,
      this.postalCode,
      this.sectorLocality,
      this.country,
      this.state,
      this.visitingCard,
      this.latitude,
      this.longitude,
      this.peopleAdded,
      this.assignedTo,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.sourceName,
      this.statusName,
      this.ownerName,
      this.documentUploadStatus,
      this.approvalData});

  LeadListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadNumber = json['lead_number'];
    userId = json['user_id'];
    leadName = json['lead_name'];
    leadType = json['lead_type'];
    company = json['company'];
    phone = json['phone'];
    email = json['email'];
    source = json['source'];
    designation = json['designation'];
    gender = json['gender'];
    status = json['status'];
    noOfProject = json['no_of_project'];
    description = json['description'];
    regionalOfc = json['regional_ofc'];
    referenceDetails = json['reference_details'];
    image = json['image'];
    audio = json['audio'];
    type = json['type'];
    addressType = json['address_type'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    cityTown = json['city_town'];
    postalCode = json['postal_code'];
    sectorLocality = json['sector_locality'];
    country = json['country'];
    state = json['state'];
    visitingCard = json['visiting_card'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    peopleAdded = json['people_added'];
    assignedTo = json['assigned_to'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sourceName = json['source_name'];
    statusName = json['status_name'];
    ownerName = json['owner_name'];
    documentUploadStatus = json['document_upload_status'];
    if (json['approval_data'] != null) {
      approvalData = <ApprovalData>[];
      json['approval_data'].forEach((v) {
        approvalData!.add(new ApprovalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_number'] = this.leadNumber;
    data['user_id'] = this.userId;
    data['lead_name'] = this.leadName;
    data['lead_type'] = this.leadType;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['source'] = this.source;
    data['designation'] = this.designation;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['no_of_project'] = this.noOfProject;
    data['description'] = this.description;
    data['regional_ofc'] = this.regionalOfc;
    data['reference_details'] = this.referenceDetails;
    data['image'] = this.image;
    data['audio'] = this.audio;
    data['type'] = this.type;
    data['address_type'] = this.addressType;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['city_town'] = this.cityTown;
    data['postal_code'] = this.postalCode;
    data['sector_locality'] = this.sectorLocality;
    data['country'] = this.country;
    data['state'] = this.state;
    data['visiting_card'] = this.visitingCard;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['people_added'] = this.peopleAdded;
    data['assigned_to'] = this.assignedTo;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['source_name'] = this.sourceName;
    data['status_name'] = this.statusName;
    data['owner_name'] = this.ownerName;
    data['document_upload_status'] = this.documentUploadStatus;
    if (this.approvalData != null) {
      data['approval_data'] =
          this.approvalData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApprovalData {
  int? id;
  dynamic quotationId;
  dynamic managerStatus;
  dynamic isManagerStatus;
  dynamic isBranchheadStatus;
  dynamic managerRemarks;
  dynamic managerName;
  dynamic managerTime;
  dynamic branchheadStatus;
  dynamic branchheadRemarks;
  dynamic brancheadTime;
  dynamic branchheadName;
  dynamic legalName;
  dynamic ceoName;
  dynamic legalStatus;
  dynamic legalRemarks;
  dynamic ceoRemarks;
  dynamic ceoRemarksTime;
  dynamic ceoStatus;
  dynamic legalTime;
  dynamic submittedAt;

  ApprovalData(
      {this.id,
      this.quotationId,
      this.managerStatus,
      this.isManagerStatus,
      this.isBranchheadStatus,
      this.managerRemarks,
      this.managerName,
      this.managerTime,
      this.branchheadStatus,
      this.branchheadRemarks,
      this.brancheadTime,
      this.branchheadName,
      this.legalName,
      this.ceoName,
      this.legalStatus,
      this.legalRemarks,
      this.ceoRemarks,
      this.ceoRemarksTime,
      this.ceoStatus,
      this.legalTime,
      this.submittedAt});

  ApprovalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    managerStatus = json['manager_status'];
    isManagerStatus = json['is_manager_status'];
    isBranchheadStatus = json['is_branchhead_status'];
    managerRemarks = json['manager_remarks'];
    managerName = json['manager_name'];
    managerTime = json['manager_time'];
    branchheadStatus = json['branchhead_status'];
    branchheadRemarks = json['branchhead_remarks'];
    brancheadTime = json['branchead_time'];
    branchheadName = json['branchhead_name'];
    legalName = json['legal_name'];
    ceoName = json['ceo_name'];
    legalStatus = json['legal_status'];
    legalRemarks = json['legal_remarks'];
    ceoRemarks = json['ceo_remarks'];
    ceoRemarksTime = json['ceo_remarks_time'];
    ceoStatus = json['ceo_status'];
    legalTime = json['legal_time'];
    submittedAt = json['submitted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['manager_status'] = this.managerStatus;
    data['is_manager_status'] = this.isManagerStatus;
    data['is_branchhead_status'] = this.isBranchheadStatus;
    data['manager_remarks'] = this.managerRemarks;
    data['manager_name'] = this.managerName;
    data['manager_time'] = this.managerTime;
    data['branchhead_status'] = this.branchheadStatus;
    data['branchhead_remarks'] = this.branchheadRemarks;
    data['branchead_time'] = this.brancheadTime;
    data['branchhead_name'] = this.branchheadName;
    data['legal_name'] = this.legalName;
    data['ceo_name'] = this.ceoName;
    data['legal_status'] = this.legalStatus;
    data['legal_remarks'] = this.legalRemarks;
    data['ceo_remarks'] = this.ceoRemarks;
    data['ceo_remarks_time'] = this.ceoRemarksTime;
    data['ceo_status'] = this.ceoStatus;
    data['legal_time'] = this.legalTime;
    data['submitted_at'] = this.submittedAt;
    return data;
  }
}

class Pagination {
  int? total;
  int? currentPage;
  int? perPage;
  int? lastPage;

  Pagination({this.total, this.currentPage, this.perPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['last_page'] = this.lastPage;
    return data;
  }
}
