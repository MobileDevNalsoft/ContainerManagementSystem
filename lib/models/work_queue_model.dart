class WorkQueue {
  int? ordersAwaitingReceiving;
  int? pendingAsn;
  int? pendingPutaways;
  int? ordersAwaitingFulfilment;
  int? loadingQueue;
  int? ordersToBeShipped;
  int? openPickingTask;
  int? pendingCycleCounts;
  int? openWorkOrders;

  WorkQueue(
      {this.ordersAwaitingReceiving,
      this.pendingAsn,
      this.pendingPutaways,
      this.ordersAwaitingFulfilment,
      this.loadingQueue,
      this.ordersToBeShipped,
      this.openPickingTask,
      this.pendingCycleCounts,
      this.openWorkOrders});

  WorkQueue.fromJson(Map<String, dynamic> json) {
    ordersAwaitingReceiving = json['orders_awaiting_receiving'];
    pendingAsn = json['pending_asn'];
    pendingPutaways = json['pending_putaways'];
    ordersAwaitingFulfilment = json['orders_awaiting_fulfilment'];
    loadingQueue = json['loading_queue'];
    ordersToBeShipped = json['orders_to_be_shipped'];
    openPickingTask = json['open_picking_task'];
    pendingCycleCounts = json['pending_cycle_counts'];
    openWorkOrders = json['open_work_orders'];
  }

}