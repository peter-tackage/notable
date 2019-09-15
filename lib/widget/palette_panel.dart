import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config.dart';
import 'package:notable/widget/selectable_cell.dart';

class PalettePanel extends StatelessWidget {
  PalettePanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildColorPalettePanel();
  }

  _ColorPaletteGrid _buildColorPalettePanel() => _ColorPaletteGrid();
}

final List<Color> availableColors = [
  ...Colors.primaries, // ignore: sdk_version_ui_as_code
  Colors.black,
  Colors.white
];

class _ColorPaletteGrid extends StatelessWidget {
  static final int fullyOpaqueAlpha = 255;

  _ColorPaletteGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingConfigBloc, DrawingConfigState>(
        builder:
            (BuildContext context, DrawingConfigState drawingConfigState) =>
                Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Row(children: <Widget>[
                      _buildColorSelection(drawingConfigState, context),
                      _buildAlphaSelection(drawingConfigState, context)
                    ])));
  }

  Widget _buildColorSelection(
      DrawingConfigState drawingConfigState, BuildContext context) {
    return Expanded(
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            children: List.generate(availableColors.length, (index) {
              return Padding(
                  padding: EdgeInsets.all(8),
                  child: SelectableCell(
                      color: availableColors[index],
                      isSelected: (drawingConfigState as DrawingConfigLoaded)
                              .drawingConfig
                              .color ==
                          availableColors[index].value,
                      onSelected: () => _selectColor(
                          availableColors[index].value,
                          _drawingConfigBlocOf(context))));
            })));
  }

  //
  // Change alpha
  //

  _buildAlphaSelection(
      DrawingConfigState drawingConfigState, BuildContext context) {
    return Row(children: <Widget>[
      _buildGradientBox(Color(
          (drawingConfigState as DrawingConfigLoaded).drawingConfig.color)),
      _buildGradientSlider(drawingConfigState, context)
    ]);
  }

  _buildGradientBox(Color selectedColor) => Container(
      width: 16,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [selectedColor, Colors.white],
      )));

  _buildGradientSlider(
      DrawingConfigState drawingConfigState, BuildContext context) {
    return RotatedBox(
        quarterTurns: 1,
        child: Slider(
            min: 0,
            max: fullyOpaqueAlpha.toDouble(),
            value: (drawingConfigState as DrawingConfigLoaded)
                .drawingConfig
                .alpha
                .toDouble(),
            onChanged: (alpha) =>
                _selectAlpha(alpha.toInt(), _drawingConfigBlocOf(context))));
  }

  DrawingConfigBloc _drawingConfigBlocOf(context) =>
      BlocProvider.of<DrawingConfigBloc>(context);

  //
  // Select color/alpha
  //

  _selectColor(color, bloc) => bloc.dispatch(SelectDrawingToolColor(color));

  _selectAlpha(alpha, bloc) => bloc.dispatch(SelectDrawingToolAlpha(alpha));
}
