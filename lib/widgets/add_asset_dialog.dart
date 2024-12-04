import 'package:cypto_currency_app/controller/assets_controller.dart';
import 'package:cypto_currency_app/models/api_response.dart';
import 'package:cypto_currency_app/services/http_service.dart';
import 'package:cypto_currency_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach(
      (coin) {
        assets.add(
          coin.name!,
        );
      },
    );
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(
    AddAssetDialogController(),
  );
  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          color: Colors.black,
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * 0.80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 99, 99, 99),
                  Color.fromARGB(255, 51, 51, 51),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _buildUi(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown for asset selection
            DropdownButton<String>(
              value: controller.selectedAsset.value,
              isExpanded: true, // Ensures the dropdown fills available space
              items: controller.assets.map((asset) {
                return DropdownMenuItem<String>(
                  // Asset selection
                  value: asset,
                  child: Row(
                    children: [
                      // Try loading the crypto logo, if it fails, show a fallback icon
                      Image.network(
                        width: 40,
                        getCryptoImageUrl(
                            asset.toString()), // Get the image URL for the coin
                        errorBuilder: (context, error, stackTrace) {
                          // If the image fails to load, show a default icon
                          return const Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                            size: 40, // Default coin icon size
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const CircularProgressIndicator(
                            color: Colors
                                .white, // Show a loading indicator while the image is loading
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        asset,
                        style: const TextStyle(
                            color: Colors.white), // Text color to white
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAsset.value = value;
                }
              },
              dropdownColor: const Color.fromARGB(
                  255, 44, 44, 44), // Dark background for dropdown
              style: const TextStyle(color: Colors.white), // White text color
            ),

            // Asset value input field
            TextField(
              onChanged: (value) {
                controller.assetValue.value = double.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey[600]!), 
                ),
                hoverColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey[400]!), 
                ),
                focusColor: Colors.grey,
                hintText: "Enter Asset Value",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70, 
                ),
                border: const OutlineInputBorder(),
              ),
              style:
                  const TextStyle(color: Colors.white),
                  cursorColor: const Color.fromARGB(255, 187, 187, 187), 
                  cursorWidth: 1.6,
            ),

            // Add asset button with MaterialButton style
            MaterialButton(
              onPressed: () {
                AssetsController assetsController = Get.find();
                assetsController.addTrackedAsset(controller.selectedAsset.value,
                    controller.assetValue.value);
                Get.back(
                  closeOverlays: true,
                );
              },
              color: const Color.fromARGB(
                  255, 136, 136, 136), // Grey background for button
              child: const Text(
                "Add Asset",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }
  }
}
