import 'package:cypto_currency_app/models/coin_data.dart';
import 'package:cypto_currency_app/utils.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final CoinData coin;

  const DetailsPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: _buildUi(context),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        coin.name!,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          children: [
            _assetPrice(context),
            const SizedBox(height: 20),
            const Text(
            "Market Supply", 
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            // textAlign: TextAlign.center,
          ),
            _assetInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _assetPrice(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Image.network(
              getCryptoImageUrl(coin.name!),
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(
                Icons.monetization_on, 
                color: Colors.white, 
                size: 40, // Default coin icon size
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "\$${coin.values?.uSD?.price?.toStringAsFixed(2)}\n",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "24h: ${_formatPercentChange(coin.values?.uSD?.percentChange24h)}\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: (coin.values?.uSD?.percentChange24h ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    TextSpan(
                      text:
                          "7d: ${_formatPercentChange(coin.values?.uSD?.percentChange7d)}\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: (coin.values?.uSD?.percentChange7d ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    TextSpan(
                      text:
                          "30d: ${_formatPercentChange(coin.values?.uSD?.percentChange30d)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: (coin.values?.uSD?.percentChange30d ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetInfo(BuildContext context) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        children: [
          _infoCard(
              "Circulating Supply", coin.circulatingSupply.toString(), "BTC"),
          _infoCard("Maximum Supply", coin.maxSupply.toString(), "BTC"),
          _infoCard("Total Supply", coin.totalSupply.toString(), "BTC"),
          _infoCard(
              "Market Cap", coin.values?.uSD?.marketCap.toString(), "USD"),
          _infoCard(
              "24h Volume", coin.values?.uSD?.volume24h.toString(), "USD"),
          _infoCard("Price (BTC)", coin.values?.bTC?.price?.toStringAsFixed(6),
              "BTC"),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String? value, String unit) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 128, 128, 128), Color.fromARGB(255, 71, 71, 71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${value ?? 'N/A'} $unit",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPercentChange(num? change) {
    if (change == null) return "N/A";
    return "${change.toStringAsFixed(2)}%";
  }
}
