// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';

// class LotTypeDropDown extends StatefulWidget {
//   LotTypeDropDown({super.key, required this.selectdLotTypeDropdown});
//   int selectdLotTypeDropdown;
//   @override
//   State<LotTypeDropDown> createState() => LotTypeDropDownState();
// }

// class LotTypeDropDownState extends State<LotTypeDropDown> {
//   late ContainerInteractionBloc _containerInteractionBloc;
//   List<String> items = ['Recommended', 'Standard', 'Custom'];

//   @override
//   void initState() {
//     super.initState();
//     // Set the default selected value here.
//     // Choose the value from your 'items' list that you want to be selected initially.
//     // Or you can select a specific item:
//     _containerInteractionBloc = context.read<ContainerInteractionBloc>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         isExpanded: true,
//         items: items
//             .map((String item) => DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(
//                     item,
//                     style: const TextStyle(
//                       fontSize: 14,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//             .toList(),
//         value: items[widget.selectdLotTypeDropdown],
//         style: TextStyle(fontSize: 18),
//         onChanged: (String? value) {
//           setState(() {
//             int index = items.indexOf(value!);
//             widget.selectdLotTypeDropdown = index;
//             _containerInteractionBloc.add(DropdownLotTypeChanged(lotTypeIndex: index));
//             _containerInteractionBloc.add(DropdownLotChanged(lotNo: null));
//           });
//         },
//         buttonStyleData: ButtonStyleData(
//           height: size.height * 0.06,
//           width: double.infinity,
//           padding: EdgeInsets.only(left: size.width * 0.01),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: Color.fromRGBO(111, 54, 167, 1),
//             ),
//             color: Color.fromRGBO(242, 228, 255, 1),
//           ),
//         ),
//         iconStyleData: const IconStyleData(
//           icon: Icon(
//             Icons.keyboard_arrow_down_rounded,
//           ),
//           iconSize: 20,
//           openMenuIcon: Icon(
//             Icons.keyboard_arrow_up_rounded,
//             size: 20,
//           ),
//           iconEnabledColor: Colors.black,
//           iconDisabledColor: Colors.black,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: size.height * 0.25,
//           width: size.height * 0.385,
//           offset: Offset(0, -size.height * 0.006),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: const Color.fromRGBO(164, 111, 218, 1),
//           ),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(40),
//             thickness: WidgetStateProperty.all<double>(6),
//             thumbVisibility: WidgetStateProperty.all<bool>(true),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 40,
//           padding: EdgeInsets.only(left: 14, right: 14),
//         ),
//       ),
//     );
//   }
// }
