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
  String? containerNbr;
  String? lotNo;
  String? arrivalTime;

  ContainerData.fromJson(Map<String, dynamic> json) {
    containerNbr = json['container_nbr'];
    lotNo = json['lot_no'];
    arrivalTime = json['arrival_time'];
  }
}

class SearchedContainer {
  String? containerNbr;
  String? area;
  String? customerName;

  SearchedContainer({this.containerNbr, this.area, this.customerName});

  SearchedContainer.fromJson(Map<String, dynamic> json) {
    containerNbr = json['container_nbr'];
    area = json['area'];
    customerName = json['customer_name'];
  }
}
