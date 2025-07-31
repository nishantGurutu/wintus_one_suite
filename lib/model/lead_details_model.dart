class LeadDetailsModel {
  bool? status;
  String? message;
  LeadDetailsData? data;

  LeadDetailsModel({this.status, this.message, this.data});

  LeadDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new LeadDetailsData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LeadDetailsData {
  int? id;
  String? leadNumber;
  int? userId;
  String? leadName;
  String? leadType;
  String? company;
  String? phone;
  String? email;
  int? source;
  dynamic designation;
  dynamic gender;
  int? status;
  dynamic noOfProject;
  String? description;
  dynamic regionalOfc;
  dynamic referenceDetails;
  String? image;
  String? audio;
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
  String? latitude;
  String? longitude;
  String? peopleAdded;
  String? assignedTo;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? sourceName;
  String? statusName;
  String? ownerName;
  List<AssignedToUsers>? assignedToUsers;
  List<AssignedToUsers>? addedUsers;

  LeadDetailsData(
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
      this.assignedToUsers,
      this.addedUsers});

  LeadDetailsData.fromJson(Map<String, dynamic> json) {
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
    if (json['assignedToUsers'] != null) {
      assignedToUsers = <AssignedToUsers>[];
      json['assignedToUsers'].forEach((v) {
        assignedToUsers!.add(new AssignedToUsers.fromJson(v));
      });
    }
    if (json['addedUsers'] != null) {
      addedUsers = <AssignedToUsers>[];
      json['addedUsers'].forEach((v) {
        addedUsers!.add(new AssignedToUsers.fromJson(v));
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
    if (this.assignedToUsers != null) {
      data['assignedToUsers'] =
          this.assignedToUsers!.map((v) => v.toJson()).toList();
    }
    if (this.addedUsers != null) {
      data['addedUsers'] = this.addedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignedToUsers {
  int? id;
  String? name;
  String? image;

  AssignedToUsers({this.id, this.name, this.image});

  AssignedToUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
