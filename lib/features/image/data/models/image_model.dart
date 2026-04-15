import 'package:hive/hive.dart';

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

class ImageModelAdapter extends TypeAdapter<ImageModel> {
  @override
  final int typeId = 4;

  @override
  ImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };

    return ImageModel(
      uid: fields[0] as String,
      originalName: fields[1] as String,
      publicUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ImageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.originalName)
      ..writeByte(2)
      ..write(obj.publicUrl);
  }
}

