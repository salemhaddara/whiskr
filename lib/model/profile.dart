import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

enum AnimalType {
  cat,
  dog;
}

@JsonSerializable()
class ProfileModel {
  final String uid;
  final String name;
  final String bio;
  final Set<String> photos;
  final int dob;
  final AnimalType type;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.bio,
    required this.photos,
    required this.dob,
    required this.type,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

}
