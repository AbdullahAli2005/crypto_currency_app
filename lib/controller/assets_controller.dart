import 'dart:convert';
import 'package:cypto_currency_app/models/api_response.dart';
import 'package:cypto_currency_app/models/coin_data.dart';
import 'package:cypto_currency_app/models/tracked_asset.dart';
import 'package:cypto_currency_app/services/http_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackAssets = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets(); // Initial call to get assets
    _loadTrackedAssetsFromStorage(); // Load tracked assets from storage
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  void addTrackedAsset(String name, double amount) async {
    trackAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
    await _saveTrackedAssetsToStorage();
  }

  void removeTrackedAssetAtIndex(int index) async {
    trackAssets.removeAt(index);
    await _saveTrackedAssetsToStorage();
  }

  Future<void> _saveTrackedAssetsToStorage() async {
    List<String> data = trackAssets.map((asset) => jsonEncode(asset)).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tracked_asset", data);
  }

  void _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_asset");
    if (data != null) {
      trackAssets.value = data
          .map(
            (e) => TrackedAsset.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
    }
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackAssets.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset asset in trackAssets) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }

  // Method to refresh portfolio data
  Future<void> refreshPortfolio() async {
    // Show loading spinner while refreshing
    loading.value = true;

    // Re-fetch coin data from the API
    await _getAssets();

    // After fetching data, update portfolio value (recalculate it)
    loading.value = false;

    // Optionally trigger a UI refresh or further actions
    update(); // Update the UI with the new portfolio value and asset prices
  }
}
