import 'package:flutter/material.dart';

enum Device {
  mobile(400),
  tab(600),
  desktop(null);

  final double? size;

  const Device(this.size);
}

Device getDevice(BuildContext context) {
  double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  if (deviceWidth > Device.tab.size!) return Device.desktop;
  if (deviceWidth > Device.mobile.size!) return Device.tab;
  return Device.mobile;
}
