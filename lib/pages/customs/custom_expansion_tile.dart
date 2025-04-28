import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class CustomExpansionTile extends StatefulWidget {
  CustomExpansionTile(
      {super.key,
      this.initialHeight = 100,
      this.initialWidth = 100,
      this.dropdownHeight = 20,
      this.margin,
      required this.onExpand,
      required this.itemCount,
      required this.childBuilder,
      required this.dropDownBuilder});
  int itemCount;
  Widget Function(double height, double width, int index) childBuilder;
  Widget Function(int index) dropDownBuilder;
  void Function(int index) onExpand;
  double initialHeight;
  double initialWidth;
  double dropdownHeight;
  EdgeInsets? margin;
  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.itemCount, widget.initialHeight);
    bottomHeights = List.filled(widget.itemCount, widget.initialHeight);
    turns = List.filled(widget.itemCount, 1);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListView.builder(
          itemCount: widget.itemCount,
          itemBuilder: (context, oindex) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: heights[oindex],
              width: widget.initialWidth,
              margin: widget.margin,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: bottomHeights[oindex],
                    width: widget.initialWidth,
                    color: Colors.transparent,
                    child: Container(
                        margin: EdgeInsets.only(top: widget.initialHeight * 0.80, left: 1, right: 1),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: widget.dropDownBuilder(oindex)),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (heights[oindex] == widget.initialHeight) {
                          openDropdownIndex = null; // Reset opened index for inner dropdowns
                        }
                        // Close other opened dropdowns
                        if (outerOpenDropdownIndex == oindex) {
                          // If the same dropdown is tapped, close it
                          heights[oindex] = heights[oindex] == widget.initialHeight ? (widget.initialHeight + widget.dropdownHeight) : widget.initialHeight;
                          bottomHeights[oindex] =
                              bottomHeights[oindex] == widget.initialHeight ? (widget.initialHeight + widget.dropdownHeight) : widget.initialHeight;
                          turns[oindex] = turns[oindex] == 0.5 ? 1 : 0.5; // Rotate icon
                          outerOpenDropdownIndex = null; // Reset opened index
                        } else {
                          // Close previously opened dropdown and open the new one
                          widget.onExpand(oindex);
                          if (outerOpenDropdownIndex != null) {
                            heights[outerOpenDropdownIndex!] = widget.initialHeight; // Reset previous dropdown
                            bottomHeights[outerOpenDropdownIndex!] = widget.initialHeight; // Reset previous bottom height
                            turns[outerOpenDropdownIndex!] = 1;
                          }
                          outerOpenDropdownIndex = oindex; // Set current index as opened
                          heights[oindex] = (widget.initialHeight + widget.dropdownHeight); // Expand current dropdown
                          bottomHeights[oindex] = (widget.initialHeight + widget.dropdownHeight); // Expand current bottom height
                          turns[oindex] = 0.5;
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        widget.childBuilder(widget.initialHeight, widget.initialWidth, oindex),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: AnimatedRotation(
                            turns: turns[oindex],
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
