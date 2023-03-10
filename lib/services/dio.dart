// ignore_for_file: inference_failure_on_instance_creation

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/common/constants/constant.dart';

import 'package:quran_app/modules/prayer_time/models/prayer_time.dart';
import 'package:quran_app/services/app_path_provider.dart';
import 'package:quran_app/services/get_timings_model.dart';

class DioHelper {
  DioHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(
            AppPathProvider.path,
            hiveBoxName: 'prayer_time_box',
          ),
          policy: CachePolicy.refreshForceCache,
          maxStale: Duration(
            days: cacheDays,
          ),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 404],
          keyBuilder: (request) {
            return request.uri.toString();
          },
        ),
      ),
    );
    //this is for avoiding certificates error cause by dio
    //https://issueexplorer.com/issue/flutterchina/dio/1285

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }
  double lat = 0;
  double long = 0;

  Future<GetTimingsResponse> getTimings(String month, String year) async {
    try {
      await getCurrentLocation().then((value) async {
        lat = value.latitude;
        long = value.longitude;
        // ignore: invalid_return_type_for_catch_error, inference_failure_on_untyped_parameter
      }).catchError((e) => debugPrint(e.toString()));

      final cityCountry = await getCityAndCountry();

      if (cityCountry.length == 2) {
        // ignore: inference_failure_on_function_invocation
        final response = await _dio.get(
          // ignore: lines_longer_than_80_chars
          '?city=${cityCountry[0]}&country=${cityCountry[1]}&method=11&month=$month&year=$year',
        );
        final result =
            PrayerTime.fromJson(response.data as Map<String, dynamic>);
        return GetTimingsResponse(data: result, city: cityCountry[0]);
      } else {
        return GetTimingsResponse(error: cityCountry[0]);
      }
    } on DioError catch (e) {
      return GetTimingsResponse(error: e.message);
    }
  }

  Future<List<String>> getCityAndCountry() async {
    try {
      final internet = await checkInternetConnection();
      if (!internet) {
        return ['No Internet Connection'];
      } else {
        if (lat != 0 && long != 0) {
          final placemarks = await placemarkFromCoordinates(
            lat,
            long,
          );
          return [
            placemarks[0].subAdministrativeArea.toString(),
            placemarks[0].country.toString()
          ];
        }
        return [];
      }
    } catch (e) {
      if (e is PlatformException) {
        debugPrint(e.toString());
      }
      return [];
    }
  }

  Future<Position> getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      await Future.error('Aktifkan Layanan Lokasi Anda.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
        await Future.error('Akses Lokasi ditolak');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Future.error(
        '''
Lokasi tidak diizinkan selamanya,
Mohon izinkan akses lokasi untuk mengakses fitur ini.
        ''',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  late Dio _dio;
}
