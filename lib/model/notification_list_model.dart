class NotificationListModel {
  bool? status;
  String? message;
  int? totalnotification;
  int? readcount;
  int? unreadcount;
  List<Readfeeds>? readfeeds;
  List<Readfeeds>? unreadfeeds;

  NotificationListModel(
      {this.status,
      this.message,
      this.totalnotification,
      this.readcount,
      this.unreadcount,
      this.readfeeds,
      this.unreadfeeds});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalnotification = json['totalnotification'];
    readcount = json['readcount'];
    unreadcount = json['unreadcount'];
    if (json['readfeeds'] != null) {
      readfeeds = <Readfeeds>[];
      json['readfeeds'].forEach((v) {
        readfeeds!.add(new Readfeeds.fromJson(v));
      });
    }
    if (json['unreadfeeds'] != null) {
      unreadfeeds = <Readfeeds>[];
      json['unreadfeeds'].forEach((v) {
        unreadfeeds!.add(new Readfeeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalnotification'] = this.totalnotification;
    data['readcount'] = this.readcount;
    data['unreadcount'] = this.unreadcount;
    if (this.readfeeds != null) {
      data['readfeeds'] = this.readfeeds!.map((v) => v.toJson()).toList();
    }
    if (this.unreadfeeds != null) {
      data['unreadfeeds'] = this.unreadfeeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Readfeeds {
  int? id;
  String? userId;
  String? type;
  String? title;
  String? description;
  Null? link;
  int? productId;
  int? status;
  String? createdAt;

  Readfeeds(
      {this.id,
      this.userId,
      this.type,
      this.title,
      this.description,
      this.link,
      this.productId,
      this.status,
      this.createdAt});

  Readfeeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    productId = json['product_id'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['description'] = this.description;
    data['link'] = this.link;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
