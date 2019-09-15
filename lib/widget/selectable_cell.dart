import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// FIXME Can this be replaced with a SizedBox?
class SelectableCell extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final void Function() onSelected;

  // TODO It would be nice for the square to bounce in and out when tapped/released.

  SelectableCell(
      {@required this.color,
      @required this.isSelected,
      @required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          decoration: _selectionDecorator(),
        ),
   //     splashColor: color,
   //     highlightColor: color,
        onTap: this.onSelected);
  }

  BoxDecoration _selectionDecorator() => BoxDecoration(
      color: color, border: isSelected ? Border.all(color: Colors.grey[200], width: 2) : null);
}
