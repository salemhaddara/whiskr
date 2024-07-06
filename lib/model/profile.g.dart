// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      photos: (json['photos'] as List<dynamic>).map((e) => e as String).toSet(),
      dob: (json['dob'] as num).toInt(),
      type: $enumDecode(_$AnimalTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'bio': instance.bio,
      'photos': instance.photos.toList(),
      'dob': instance.dob,
      'type': _$AnimalTypeEnumMap[instance.type]!,
    };

const _$AnimalTypeEnumMap = {
  AnimalType.cat: 'cat',
  AnimalType.dog: 'dog',
};
