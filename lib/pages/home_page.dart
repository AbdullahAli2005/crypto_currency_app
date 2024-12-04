import 'dart:io';
import 'package:cypto_currency_app/pages/details_page.dart';
import 'package:cypto_currency_app/widgets/add_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cypto_currency_app/pages/profile_page.dart';
import 'package:cypto_currency_app/controller/assets_controller.dart';
import 'package:cypto_currency_app/models/tracked_asset.dart';
import 'package:cypto_currency_app/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AssetsController assetsController = Get.find();
  String? userProfileImageUrl;
  String? userName;

  Future<void> _clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

  @override
  void initState() {
    super.initState();
    _clearSharedPreferences();
    _loadUserProfile(); // Load profile information when the page loads
  }

  // Load user profile info from SharedPreferences
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userProfileImageUrl = prefs.getString('userProfileImageUrl');
      userName = prefs.getString('userName');
    });
  }

  // Method to refresh the portfolio data (can be customized based on your data fetching)
  Future<void> _refreshPortfolioData() async {
    // Here, you can reload data from an API or refresh your assetsController if needed
    await assetsController
        .refreshPortfolio(); // Add refresh logic to your controller
    setState(() {}); // Trigger a UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black, // Set background color to black
      appBar: _appBar(context),
      body: _buildUi(context),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // AppBar with the profile image or default icon
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 45,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.blueAccent,
              image: DecorationImage(
                image: AssetImage("assets/CryptoVaultLogo.png"),
              ),
            ),
          ),
          const Text(
            'CryptoVault',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () async {
            // Navigate to the Profile Page when the avatar is clicked
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
            // Reload user profile after returning from the profile page
            _loadUserProfile();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800],
              backgroundImage: userProfileImageUrl != null
                  ? FileImage(File(userProfileImageUrl!))
                  : null,
              child: userProfileImageUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              _portfolioValue(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _portfoliosSection(context), // Change to portfolio section
              _trackedAssetsList(context),
            ],
          ),
        ),
      ),
    );
  }

  // Method to create the portfolio value card
  Widget _portfolioValue(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 128, 128, 128),
              Color.fromARGB(255, 58, 58, 58)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.22,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Portfolio value",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            Text(
              "\$${assetsController.getPortfolioValue().toStringAsFixed(2)}",
              maxLines: 1,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  // Portfolio section (now with refresh button)
  Widget _portfoliosSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Portfolios",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 75, 74, 74), // Set the background color to grey
              borderRadius: BorderRadius.circular(
                  18), // Optional: rounded corners for the background
            ),
            child: IconButton(
              iconSize: 16,
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed:
                  _refreshPortfolioData, // Refresh the portfolio when clicked
            ),
          ),
        ),
      ],
    );
  }

  Widget _trackedAssetsList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: assetsController.trackAssets.length,
        itemBuilder: (context, index) {
          TrackedAsset trackedAsset = assetsController.trackAssets[index];
          return Dismissible(
  key: Key('${trackedAsset.name!}_$index'), // Unique key for each item
  direction: DismissDirection.endToStart,
  onDismissed: (direction) {
    setState(() {
      // Safely remove the asset from the controller's list
      assetsController.trackAssets.removeAt(index);
    });

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${trackedAsset.name} removed!")),
    );
  },
  background: Container(
    alignment: Alignment.centerRight,
    color: Colors.redAccent,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  child: Card(
    elevation: 8.0,
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.grey[850],
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          getCryptoImageUrl(trackedAsset.name!),
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.monetization_on,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      title: Text(
        trackedAsset.name!,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        "USD: ${assetsController.getAssetPrice(trackedAsset.name!).toStringAsFixed(2)}",
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        trackedAsset.amount.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: () {
        Get.to(() => DetailsPage(
              coin: assetsController.getCoinData(trackedAsset.name!)!,
            ));
      },
    ),
  ),
);

        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 77, 76, 76),
      onPressed: () {
        Get.dialog(AddAssetDialog());
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
