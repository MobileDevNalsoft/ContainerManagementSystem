class Summary {
  AreaSummary? yard;
  AreaSummary? refrigerated;
  AreaSummary? dry;
  AreaSummary? empty;
  AreaSummary? damaged;

  Summary({this.yard, this.refrigerated, this.dry, this.empty, this.damaged});

  Summary.fromJson(Map<String, dynamic> json) {
    yard = json['yard'] != null ? AreaSummary.fromJson(json['yard']) : null;
    refrigerated = json['refrigerated'] != null ? AreaSummary.fromJson(json['refrigerated']) : null;
    dry = json['dry'] != null ? AreaSummary.fromJson(json['dry']) : null;
    empty = json['empty'] != null ? AreaSummary.fromJson(json['empty']) : null;
    damaged = json['damaged'] != null ? AreaSummary.fromJson(json['damaged']) : null;
  }
}

class AreaSummary {
  int? totalLots;
  int? availableLots;
  int? occupiedLots;
  int? totalSlots;
  int? availableSlots;
  int? occupiedSlots;

  AreaSummary({this.totalLots, this.availableLots, this.occupiedLots, this.totalSlots, this.availableSlots, this.occupiedSlots});

  AreaSummary.fromJson(Map<String, dynamic> json) {
    totalLots = json['total_lots'];
    availableLots = json['available_lots'];
    occupiedLots = json['occupied_lots'];
    totalSlots = json['total_slots'];
    availableSlots = json['available_slots'];
    occupiedSlots = json['occupied_slots'];
  }
}
