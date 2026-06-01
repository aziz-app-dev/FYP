import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/home/home_data_model.dart';
import '../../res/app_url/app_url.dart';

/// Key under which the raw /api/home/ JSON is cached in GetStorage.
const String _kHomeCacheKey = 'cached_home_data';

class FetchHomeDataHook {
  /// The data currently visible — cached value first, replaced by fresh
  /// API response when it arrives.
  final HomeDataModel? data;

  /// True while the network request is in-flight AND we have no cached
  /// data to show. False when cached data is already on screen (even if
  /// a background refresh is still running).
  final bool isLoading;

  /// Set when the network request fails. UI can show an inline banner.
  /// `data` may still be non-null (from cache) when this is set.
  final Exception? error;

  /// True when the current [data] was served from local cache and we
  /// couldn't reach the server to refresh it.
  final bool isFromCache;

  final VoidCallback? refetch;

  FetchHomeDataHook({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.isFromCache,
    required this.refetch,
  });
}

FetchHomeDataHook useFetchHomeData(BuildContext context) {
  final homeData = useState<HomeDataModel?>(null);
  final isLoading = useState<bool>(true);
  final error = useState<Exception?>(null);
  final isFromCache = useState<bool>(false);

  Future<void> fetchData() async {
    final box = GetStorage();

    // 1. Load cached data first (if any) so UI shows something instantly.
    final String? cachedJson = box.read(_kHomeCacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty && homeData.value == null) {
      try {
        homeData.value = homeDataModelFromJson(cachedJson);
        isFromCache.value = true;
        // Don't flip isLoading off yet — we still want to fetch fresh data,
        // but UI can already show the cached data without a blocking spinner.
        isLoading.value = false;
      } catch (e) {
        // Corrupt cache — clear it.
        await box.remove(_kHomeCacheKey);
      }
    } else if (homeData.value == null) {
      // No cache and no current data -> show loader.
      isLoading.value = true;
    }

    // 2. Fire network request to refresh.
    final String? accessToken = box.read("token");
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };

    try {
      final url = Uri.parse('${AppUrl.baseUrl}/api/home/');
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        // Success → update state + cache.
        homeData.value = homeDataModelFromJson(response.body);
        isFromCache.value = false;
        error.value = null;
        await box.write(_kHomeCacheKey, response.body);

        if (homeData.value?.defaultAddress != null) {
          box.write('defultAddress', true);
        } else if (accessToken != null) {
          box.write('defultAddress', false);
        }
      } else {
        error.value = Exception(
            'Server returned ${response.statusCode}. Showing cached data.');
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        error.value = Exception(
            'No internet connection. Showing cached data if available.');
      }
    } on http.ClientException catch (_) {
      if (context.mounted) {
        error.value = Exception(
            'Cannot reach server. Showing cached data if available.');
      }
    } on TimeoutException catch (_) {
      if (context.mounted) {
        error.value = Exception('Server is slow. Showing cached data.');
      }
    } catch (e) {
      if (context.mounted) {
        if (kDebugMode) debugPrint('Home data fetch error: $e');
        error.value = e is Exception
            ? e
            : Exception('Unexpected error: $e');
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, const []);

  void refetch() {
    if (homeData.value == null) {
      isLoading.value = true;
    }
    fetchData();
  }

  return FetchHomeDataHook(
    data: homeData.value,
    isLoading: isLoading.value,
    error: error.value,
    isFromCache: isFromCache.value,
    refetch: refetch,
  );
}
