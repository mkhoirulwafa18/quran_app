// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurahImpl _$$SurahImplFromJson(Map<String, dynamic> json) => _$SurahImpl(
      number: json['number'] as int? ?? 0,
      sequence: json['sequence'] as int? ?? 0,
      numberOfVerses: json['numberOfVerses'] as int? ?? 0,
      nameShort: json['nameShort'] as String? ?? '',
      nameLong: json['nameLong'] as String? ?? '',
      nameTransliteration: json['nameTransliteration'] as String? ?? '',
      nameTranslation: json['nameTranslation'] as String? ?? '',
      revelation: json['revelation'] ?? '',
      tafsir: json['tafsir'] ?? '',
    );

Map<String, dynamic> _$$SurahImplToJson(_$SurahImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'sequence': instance.sequence,
      'numberOfVerses': instance.numberOfVerses,
      'nameShort': instance.nameShort,
      'nameLong': instance.nameLong,
      'nameTransliteration': instance.nameTransliteration,
      'nameTranslation': instance.nameTranslation,
      'revelation': instance.revelation,
      'tafsir': instance.tafsir,
    };
