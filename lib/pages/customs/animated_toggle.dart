import 'package:flutter/material.dart';

class AnimatedToggleButton extends StatefulWidget {
  AnimatedToggleButton({
    super.key,
    this.height = 50,
    this.width = 150,
    this.toggleColor = Colors.blueAccent,
    required this.onToggle,
  });
  double height;
  double width;
  Color toggleColor;
  void Function(bool value) onToggle;

  @override
  _AnimatedToggleButtonState createState() => _AnimatedToggleButtonState();
}

class _AnimatedToggleButtonState extends State<AnimatedToggleButton> {
  bool isLotsSelected = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLotsSelected = !isLotsSelected;
          widget.onToggle(isLotsSelected);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Stack(
          children: [
            // moving highlight
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment: isLotsSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: widget.width * 0.45,
                height: widget.height * 0.95,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: widget.toggleColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // text labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Lots',
                        style: TextStyle(color: isLotsSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Slots',
                        style: TextStyle(color: isLotsSelected ? Colors.grey : Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
