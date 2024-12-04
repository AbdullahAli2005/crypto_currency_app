import 'price_history_data.dart';
import 'coin_data.dart';

class CurrenciesListAPIResponse {
  List<CoinData>? data;
  Status? status;
  Meta? meta;

  CurrenciesListAPIResponse({this.data, this.status, this.meta});

  CurrenciesListAPIResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CoinData>[];
      json['data'].forEach((v) {
        data!.add(CoinData.fromJson(v));
      });
    }
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class PriceHistoryAPIResponse {
  PriceHistoryData? data;
  Status? status;

  PriceHistoryAPIResponse({this.data, this.status});

  PriceHistoryAPIResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? PriceHistoryData.fromJson(json['data']) : null;
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Status {
  bool? success;
  String? time;
  int? code;
  String? message;
  int? responseTime;
  int? creditsCost;

  Status(
      {this.success,
      this.time,
      this.code,
      this.message,
      this.responseTime,
      this.creditsCost});

  Status.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    time = json['time'];
    code = json['code'];
    message = json['message'];
    responseTime = json['responseTime'];
    creditsCost = json['creditsCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['time'] = time;
    data['code'] = code;
    data['message'] = message;
    data['responseTime'] = responseTime;
    data['creditsCost'] = creditsCost;
    return data;
  }
}

class Meta {
  int? count;

  Meta({this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}
