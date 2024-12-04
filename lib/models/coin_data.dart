class CoinData {
  int? id;
  String? slug;
  String? symbol;
  String? name;
  String? type;
  String? category;
  num? rank;
  num? volume24hBase;
  Values? values;
  List<Tokens>? tokens;
  List<Links>? links;
  num? circulatingSupply;
  num? totalSupply;
  num? maxSupply;
  String? lastUpdated;
  Images? images;

  CoinData(
      {this.id,
      this.slug,
      this.symbol,
      this.name,
      this.type,
      this.category,
      this.rank,
      this.volume24hBase,
      this.values,
      this.tokens,
      this.links,
      this.circulatingSupply,
      this.totalSupply,
      this.maxSupply,
      this.lastUpdated,
      this.images});

  CoinData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    symbol = json['symbol'];
    name = json['name'];
    type = json['type'];
    category = json['category'];
    rank = json['rank'];
    volume24hBase = json['volume24hBase'];
    values = json['values'] != null ? Values.fromJson(json['values']) : null;
    if (json['tokens'] != null) {
      tokens = <Tokens>[];
      json['tokens'].forEach((v) {
        tokens!.add(Tokens.fromJson(v));
      });
    }
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    circulatingSupply = json['circulatingSupply'];
    totalSupply = json['totalSupply'];
    maxSupply = json['maxSupply'];
    lastUpdated = json['lastUpdated'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['symbol'] = symbol;
    data['name'] = name;
    data['type'] = type;
    data['category'] = category;
    data['rank'] = rank;
    data['volume24hBase'] = volume24hBase;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.map((v) => v.toJson()).toList();
    }
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['circulatingSupply'] = circulatingSupply;
    data['totalSupply'] = totalSupply;
    data['maxSupply'] = maxSupply;
    data['lastUpdated'] = lastUpdated;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    return data;
  }
}

class Values {
  USD? uSD;
  BTC? bTC;
  BTC? eTH;

  Values({this.uSD, this.bTC, this.eTH});

  Values.fromJson(Map<String, dynamic> json) {
    uSD = json['USD'] != null ? USD.fromJson(json['USD']) : null;
    bTC = json['BTC'] != null ? BTC.fromJson(json['BTC']) : null;
    eTH = json['ETH'] != null ? BTC.fromJson(json['ETH']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uSD != null) {
      data['USD'] = uSD!.toJson();
    }
    if (bTC != null) {
      data['BTC'] = bTC!.toJson();
    }
    if (eTH != null) {
      data['ETH'] = eTH!.toJson();
    }
    return data;
  }
}

class USD {
  num? price;
  num? marketCap;
  num? volume24h;
  num? high24h;
  num? low24h;
  double? percentChange24h;
  num? percentChange7d;
  num? percentChange30d;
  num? percentChange3m;
  num? percentChange6m;

  USD(
      {this.price,
      this.marketCap,
      this.volume24h,
      this.high24h,
      this.low24h,
      this.percentChange24h,
      this.percentChange7d,
      this.percentChange30d,
      this.percentChange3m,
      this.percentChange6m});

  USD.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    marketCap = json['marketCap'];
    volume24h = json['volume24h'];
    high24h = json['high24h'];
    low24h = json['low24h'];
    percentChange24h = json['percentChange24h'];
    percentChange7d = json['percentChange7d'];
    percentChange30d = json['percentChange30d'];
    percentChange3m = json['percentChange3m'];
    percentChange6m = json['percentChange6m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['marketCap'] = marketCap;
    data['volume24h'] = volume24h;
    data['high24h'] = high24h;
    data['low24h'] = low24h;
    data['percentChange24h'] = percentChange24h;
    data['percentChange7d'] = percentChange7d;
    data['percentChange30d'] = percentChange30d;
    data['percentChange3m'] = percentChange3m;
    data['percentChange6m'] = percentChange6m;
    return data;
  }
}

class BTC {
  num? price;
  num? marketCap;
  num? volume24h;
  num? high24h;
  num? low24h;
  num? percentChange24h;
  num? percentChange7d;
  num? percentChange30d;
  num? percentChange3m;
  num? percentChange6m;

  BTC(
      {this.price,
      this.marketCap,
      this.volume24h,
      this.high24h,
      this.low24h,
      this.percentChange24h,
      this.percentChange7d,
      this.percentChange30d,
      this.percentChange3m,
      this.percentChange6m});

  BTC.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    marketCap = json['marketCap'];
    volume24h = json['volume24h'];
    high24h = json['high24h'];
    low24h = json['low24h'];
    percentChange24h = json['percentChange24h'];
    percentChange7d = json['percentChange7d'];
    percentChange30d = json['percentChange30d'];
    percentChange3m = json['percentChange3m'];
    percentChange6m = json['percentChange6m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['marketCap'] = marketCap;
    data['volume24h'] = volume24h;
    data['high24h'] = high24h;
    data['low24h'] = low24h;
    data['percentChange24h'] = percentChange24h;
    data['percentChange7d'] = percentChange7d;
    data['percentChange30d'] = percentChange30d;
    data['percentChange3m'] = percentChange3m;
    data['percentChange6m'] = percentChange6m;
    return data;
  }
}

class Tokens {
  String? tokenAddress;
  Platform? platform;

  Tokens({this.tokenAddress, this.platform});

  Tokens.fromJson(Map<String, dynamic> json) {
    tokenAddress = json['tokenAddress'];
    platform =
        json['platform'] != null ? Platform.fromJson(json['platform']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokenAddress'] = tokenAddress;
    if (platform != null) {
      data['platform'] = platform!.toJson();
    }
    return data;
  }
}

class Platform {
  int? id;
  String? slug;
  String? name;

  Platform({this.id, this.slug, this.name});

  Platform.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    return data;
  }
}

class Links {
  String? type;
  String? value;

  Links({this.type, this.value});

  Links.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class Images {
  String? s16x16;
  String? s200x200;
  String? s60x60;

  Images({this.s16x16, this.s200x200, this.s60x60});

  Images.fromJson(Map<String, dynamic> json) {
    s16x16 = json['16x16'];
    s200x200 = json['200x200'];
    s60x60 = json['60x60'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['16x16'] = s16x16;
    data['200x200'] = s200x200;
    data['60x60'] = s60x60;
    return data;
  }
}
