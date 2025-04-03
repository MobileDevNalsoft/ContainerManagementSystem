class Areas {
  Area? dryArea;
  Area? refrigeratedArea;
  Area? damagedArea;
  Area? emptyArea;

  Areas({
    this.dryArea,
    this.refrigeratedArea,
    this.damagedArea,
    this.emptyArea,
  });

  Areas.fromJson(Map<String, dynamic> json) {
    dryArea = Area.fromJson(json['dry_area']);
    refrigeratedArea = Area.fromJson(json['refrigerated_area']);
    damagedArea = Area.fromJson(json['damaged_area']);
    emptyArea = Area.fromJson(json['empty_area']);
  }
}

class Area {
  List<Lot>? lots;

  Area({this.lots});

  Area.fromJson(Map<String, dynamic> json) {
    lots = json.entries.map((lot) => Lot.fromJson({lot.key: lot.value})).toList();
  }
}

class Lot {
  String? lot;
  List<LotContainer>? containers;

  Lot({this.lot, this.containers});

  Lot.fromJson(Map<String, dynamic> json) {
    lot = json.keys.first;
    containers = (json.values.toList().first as List).map((container) => LotContainer.fromJson(container)).toList();
  }
}

class LotContainer {
  String? containerNbr;
  String? arrivalTime;
  String? customerName;

  LotContainer({this.containerNbr, this.arrivalTime, this.customerName});

  LotContainer.fromJson(Map<String, dynamic> json) {
    containerNbr = json['container_nbr'];
    arrivalTime = json['arrival_time'];
    customerName = json['customer_name'];
  }
}

class AreaResponse<T> {
  int? responseCode;
  String? responseMessage;
  List<T>? data;

  AreaResponse({this.responseCode, this.responseMessage, this.data});

  AreaResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = (json['data'] as List).map((item) => fromJsonT(item)).toList();
    }
  }
}
