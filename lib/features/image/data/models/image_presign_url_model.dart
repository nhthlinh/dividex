class ImagePresignUrlResponseModel {
  final String uid;
  final String url;
  final String fileName;

  ImagePresignUrlResponseModel({
    required this.uid,
    required this.url,
    required this.fileName,
  });

  factory ImagePresignUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return ImagePresignUrlResponseModel(
      uid: json['uid'],
      url: json['url'],
      fileName: json['file_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'url': url, 'file_name': fileName};
  }
}

enum AttachmentType { group, user, expense, message, other }

class ImagePresignUrlInputModel {
  final String fileName;
  final AttachmentType attachmentType;
  final int fileSize;

  ImagePresignUrlInputModel({
    required this.fileName,
    required this.attachmentType,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'file_name': fileName,
      'attachment_type': attachmentType.name.toUpperCase(),
      'file_size': fileSize,
    };
  }

  factory ImagePresignUrlInputModel.fromJson(Map<String, dynamic> json) {
    return ImagePresignUrlInputModel(
      fileName: json['file_name'],
      attachmentType: AttachmentType.values.firstWhere(
        (e) => e.name == json['attachment_type'],
      ),
      fileSize: json['file_size'],
    );
  }
}
