class AnyversaryBirthdayModel {
  bool? status;
  String? message;
  List<AnyversaryData>? data;

  AnyversaryBirthdayModel({this.status, this.message, this.data});

  AnyversaryBirthdayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AnyversaryData>[];
      json['data'].forEach((v) {
        data!.add(new AnyversaryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnyversaryData {
  int? id;
  String? name;
  String? image;
  String? eventDate;
  String? eventType;
  String? departmentName;
  String? roleName;
  int? chatId;
  String? msg;

  AnyversaryData(
      {this.id,
      this.name,
      this.image,
      this.eventDate,
      this.eventType,
      this.departmentName,
      this.roleName,
      this.chatId,
      this.msg});

  AnyversaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    eventDate = json['event_date'];
    eventType = json['event_type'];
    departmentName = json['department_name'];
    roleName = json['role_name'];
    chatId = json['chat_id'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['event_date'] = this.eventDate;
    data['event_type'] = this.eventType;
    data['department_name'] = this.departmentName;
    data['role_name'] = this.roleName;
    data['chat_id'] = this.chatId;
    data['msg'] = this.msg;
    return data;
  }
}
