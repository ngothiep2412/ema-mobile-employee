class ChatUserModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? lastMessageSentAt;
  LastMessageSent? lastMessageSent;
  Author? creator;
  Author? recipient;
  bool? online;

  ChatUserModel({this.id, this.createdAt, this.updatedAt, this.lastMessageSentAt, this.lastMessageSent, this.creator, this.recipient});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    lastMessageSentAt = json['lastMessageSentAt'];
    lastMessageSent = json['lastMessageSent'] != null ? LastMessageSent.fromJson(json['lastMessageSent']) : null;
    creator = json['creator'] != null ? Author.fromJson(json['creator']) : null;
    recipient = json['recipient'] != null ? Author.fromJson(json['recipient']) : null;
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['online'] = this.online;
    data['lastMessageSentAt'] = this.lastMessageSentAt;
    if (this.lastMessageSent != null) {
      data['lastMessageSent'] = this.lastMessageSent!.toJson();
    }
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }

    return data;
  }
}

class LastMessageSent {
  String? id;
  String? content;
  Author? author;

  LastMessageSent({this.id, this.content, this.author});

  LastMessageSent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

class Author {
  String? id;
  String? email;
  Profile? profile;

  Author({this.id, this.email, this.profile});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? avatar;

  Profile({this.fullName, this.avatar});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    return data;
  }
}
