class UploadedFileModel {
  int? id;
  String? fileUrl;
  int? createdAt;
  String? userName;
  String? profileImage;
  String? email;

  UploadedFileModel({
    this.id,
    this.fileUrl,
    this.createdAt,
    this.userName,
    this.profileImage,
    this.email,
  });
  UploadedFileModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fileUrl = map['fileUrl'];
    createdAt = map["createdAt"];
    userName = map['userName'];
    profileImage = map['profileImage'];
    email = map["email"];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'fileUrl': fileUrl,
      'createdAt': createdAt,
      'userName': userName,
      'profileImage': profileImage,
      'email': email,
    };
    return map;
  }
}
