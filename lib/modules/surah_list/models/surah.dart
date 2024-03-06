import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'surah.freezed.dart';
part 'surah.g.dart';

@freezed
class Surah with _$Surah {
  const factory Surah({
    @Default(0) int number,
    @Default(0) int sequence,
    @Default(0) int numberOfVerses,
    @Default('') String nameShort,
    @Default('') String nameLong,
    @Default('') String nameTransliteration,
    @Default('') String nameTranslation,
    @Default('') dynamic revelation,
    @Default('') dynamic tafsir,
  }) = _Surah;

  factory Surah.fromJson(Map<String, Object?> json) => _$SurahFromJson(json);
}

List<Surah> surahFromJson(String str) => List<Surah>.from(
      // ignore: avoid_dynamic_calls
      json
          .decode(str)
          // ignore: inference_failure_on_untyped_parameter
          .map((surah) => Surah.fromJson(surah as Map<String, dynamic>)) as Iterable<dynamic>,
    );
