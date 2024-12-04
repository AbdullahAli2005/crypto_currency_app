class TrackedAsset {
  String? name;
  double? amount;

  TrackedAsset({this.name, this.amount});

  TrackedAsset.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}
