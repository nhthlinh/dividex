class ImageModel {
  final String uid;
  final String originalName;
  final String publicUrl;

  ImageModel({
    required this.uid,
    required this.originalName,
    required this.publicUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      uid: json['uid'],
      originalName: json['original_name'],
      publicUrl: json['public_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'original_name': originalName,
      'public_url': publicUrl,
    };
  }
}
