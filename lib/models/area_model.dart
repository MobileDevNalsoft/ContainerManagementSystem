class Customer {
  String? customerName;
  List<ContainerData>? containers;

  Customer.fromJson(Map<String, dynamic> json) {
    customerName = json.keys.first;
    if (json.values.first != null) {
      containers = (json.values.first as List).map((container) => ContainerData.fromJson(container)).toList();
    }
  }
}

class ContainerData {
  String? shipmentNbr;
  String? containerNbr;
  String? liner;
  String? lotNo;
  int? level;
  DateTime? arrivalTime;
  DateTime? expectedEndTime;
  int? days;
  String? toArea;

  ContainerData.fromJson(Map<String, dynamic> json) {
    shipmentNbr = json['shipment'];
    containerNbr = json['container_nbr'];
    liner = json['liner'];
    lotNo = json['lot_no'];
    toArea = json['to_area'];
    level = json['level'];
    arrivalTime = DateTime.parse(json['arrival_time']);
    expectedEndTime = DateTime.parse(json['expected_end_time']);
    days = json['days'];
  }
}
