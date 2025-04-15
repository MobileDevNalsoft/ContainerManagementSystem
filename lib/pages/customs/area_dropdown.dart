import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';

class AreaDropDown extends StatefulWidget {
  AreaDropDown({super.key,this.selectdAreaDropdown});
  String? selectdAreaDropdown;
  @override
  State<AreaDropDown> createState() => _AreaDropDownState();
}

class _AreaDropDownState extends State<AreaDropDown> {
  late ContainerInteractionBloc _containerInteractionBloc;
  List<String> items = ['refrigerated', 'dry', 'damaged', 'empty'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Set the default selected value here.
    // Choose the value from your 'items' list that you want to be selected initially.
    selectedValue = widget.selectdAreaDropdown; // Selects the first item ('Refrigerated') by default.
    // Or you can select a specific item:
    // selectedValue = 'Damaged';
    _containerInteractionBloc = context.read<ContainerInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Gap(size.width * 0.02),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(111, 54, 167, 1),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(111, 54, 167, 1),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            _containerInteractionBloc.add(DropdownAreaChanged(area: value!));
          });
        },
        buttonStyleData: ButtonStyleData(
          height: size.height * 0.06,
          width: double.infinity,
          padding: EdgeInsets.only(left: size.width * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Color.fromRGBO(111, 54, 167, 1),
            ),
            color: const Color.fromRGBO(164, 111, 218, 1),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Color.fromRGBO(111, 54, 167, 1),
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: size.height * 0.25,
          width: size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromRGBO(164, 111, 218, 1),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
