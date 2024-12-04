class PriceHistoryData {
  String? currency;
  List<String>? dates;
  List<double>? prices;
  List<int>? volumes;

  PriceHistoryData({this.currency, this.dates, this.prices, this.volumes});

  PriceHistoryData.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    dates = json['dates'].cast<String>();
    prices = json['prices'].cast<double>();
    volumes = json['volumes'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['dates'] = dates;
    data['prices'] = prices;
    data['volumes'] = volumes;
    return data;
  }
}
