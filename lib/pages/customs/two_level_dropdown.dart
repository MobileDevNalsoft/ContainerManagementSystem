import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TwoLevelDropdown extends StatefulWidget {
  TwoLevelDropdown({super.key, required this.l1StyleData, required this.l2StyleData});
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;

  @override
  _TwoLevelDropdownState createState() => _TwoLevelDropdownState();
}

class _TwoLevelDropdownState extends State<TwoLevelDropdown> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.l1StyleData.itemCount, widget.l1StyleData.height);
    bottomHeights = List.filled(widget.l1StyleData.itemCount, widget.l1StyleData.height);
    turns = List.filled(widget.l1StyleData.itemCount, 1);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListView.builder(
          itemCount: widget.l1StyleData.itemCount,
          itemBuilder: (context, oindex) {
            int l2ItemCount = widget.l2StyleData.itemCount(oindex);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: heights[oindex],
              width: widget.l1StyleData.width,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: bottomHeights[oindex],
                    width: widget.l1StyleData.width,
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 65, bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.dropDownColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: l2ItemCount,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: const EdgeInsets.all(10),
                                  height: widget.l2StyleData.height,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    color: widget.l2StyleData.color,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: LayoutBuilder(builder: (context, lsize) {
                                    return widget.l2StyleData.builder(lsize, oindex, index);
                                  }));
                            }),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (heights[oindex] == widget.l1StyleData.height) {
                          openDropdownIndex = null; // Reset opened index for inner dropdowns
                        }
                        // Close other opened dropdowns
                        if (outerOpenDropdownIndex == oindex) {
                          // If the same dropdown is tapped, close it
                          heights[oindex] = heights[oindex] == widget.l1StyleData.height
                              ? (l2ItemCount) * (widget.l2StyleData.height + 5) + (widget.l1StyleData.height + 25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (l2ItemCount) * (widget.l2StyleData.height + 5) + (widget.l1StyleData.height + 25)
                              : widget.l1StyleData.height;
                          turns[oindex] = turns[oindex] == 0.5 ? 1 : 0.5; // Rotate icon
                          outerOpenDropdownIndex = null; // Reset opened index
                        } else {
                          // Close previously opened dropdown and open the new one
                          if (outerOpenDropdownIndex != null) {
                            heights[outerOpenDropdownIndex!] = widget.l1StyleData.height; // Reset previous dropdown
                            bottomHeights[outerOpenDropdownIndex!] = widget.l1StyleData.height; // Reset previous bottom height
                            turns[outerOpenDropdownIndex!] = 1;
                          }
                          outerOpenDropdownIndex = oindex; // Set current index as opened
                          heights[oindex] = (l2ItemCount) * (widget.l2StyleData.height + 5) + (widget.l1StyleData.height + 25); // Expand current dropdown
                          bottomHeights[oindex] =
                              (l2ItemCount) * (widget.l2StyleData.height + 5) + (widget.l1StyleData.height + 25); // Expand current bottom height
                          turns[oindex] = 0.5;
                        }
                      });
                    },
                    child: Container(
                      height: widget.l1StyleData.height,
                      width: widget.l1StyleData.width,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.color, // Purple background
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LayoutBuilder(builder: (context, lsize) {
                        return Row(
                          children: [
                            Image.asset(
                              widget.l1StyleData.iconPath,
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              widget.l1StyleData.title(oindex),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Spacer(),
                            Container(
                              height: widget.l1StyleData.height * 0.5,
                              decoration: BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: widget.l1StyleData.width * 0.1,
                                      child: Text(
                                        l2ItemCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: lsize.maxHeight * 0.25),
                                      )),
                                  AnimatedRotation(
                                    turns: turns[oindex],
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(widget.l1StyleData.width * 0.02)
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class L1StyleData {
  double height;
  double width;
  Color? color;
  Color? dropDownColor;
  int itemCount;
  String iconPath;
  String Function(int index) title;
  L1StyleData(
      {required this.height,
      required this.width,
      this.color = const Color.fromRGBO(68, 98, 136, 1),
      this.dropDownColor = const Color.fromRGBO(194, 213, 238, 1),
      required this.iconPath,
      required this.title,
      required this.itemCount});
}

class L2StyleData {
  double height;
  Color? color;
  int Function(int index) itemCount;
  Widget Function(BoxConstraints lsize, int l1Index, int l2Index) builder;
  L2StyleData({required this.height, this.color = Colors.white, required this.itemCount, required this.builder});
}
