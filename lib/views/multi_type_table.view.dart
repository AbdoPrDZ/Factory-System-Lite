import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/model.dart';
import '../src/theme.dart';
import 'dropdown.view.dart';
import 'table.view.dart';

class MultiTypeStreamTableView extends StatefulWidget {
  final Stream<List<Model>> modelsStream;
  final List<TableType> types;
  final int initialType;
  // final CellSetting? cellSetting;
  final Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell;
  final EdgeInsets? margin, padding;
  final String? title;
  final Function(TableViewCell? cell, Model model)? onCellTap;
  final Function(TableType type)? onTypeChange;

  const MultiTypeStreamTableView({
    Key? key,
    required this.types,
    this.initialType = 0,
    required this.modelsStream,
    // this.cellSetting,
    this.onRenderCell,
    this.margin,
    this.padding,
    this.title,
    this.onCellTap,
    this.onTypeChange,
  }) : super(key: key);

  @override
  State<MultiTypeStreamTableView> createState() =>
      _MultiTypeStreamTableViewState();
}

class _MultiTypeStreamTableViewState extends State<MultiTypeStreamTableView> {
  late int currentTypeIndex;

  @override
  void initState() {
    super.initState();
    currentTypeIndex = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return StreamTableView(
      modelsStream: widget.modelsStream,
      columns: widget.types[currentTypeIndex].columns,
      cellSetting: widget.types[currentTypeIndex].cellSetting,
      margin: widget.margin,
      padding: widget.padding,
      onRenderCell: widget.onRenderCell,
      title: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.title != null)
            Text(
              widget.title!.replaceAll(
                '{currentType}',
                widget.types[currentTypeIndex].name,
              ),
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          Flexible(
            child: DropDownView<int>(
              value: currentTypeIndex,
              items: [
                for (int index = 0; index < widget.types.length; index++)
                  DropdownMenuItem(
                    value: index,
                    child: Text(
                      widget.types[index].name,
                    ),
                  )
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    currentTypeIndex = value;
                    if (widget.onTypeChange != null) {
                      widget.onTypeChange!(widget.types[currentTypeIndex]);
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
      avaliableModels: widget.types[currentTypeIndex].avaliableModels,
      onCellTap: widget.onCellTap,
    );
  }
}

class MultiTypeTableView extends StatefulWidget {
  final List<Model> models;
  final List<TableType> types;
  final int initialType;
  // final CellSetting? cellSetting;
  final Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell;
  final EdgeInsets? margin, padding;
  final String? title;
  final Function(TableViewCell? cell, Model model)? onCellTap;
  final Function(TableType type)? onTypeChange;

  const MultiTypeTableView({
    Key? key,
    required this.types,
    this.initialType = 0,
    required this.models,
    // this.cellSetting,
    this.onRenderCell,
    this.margin,
    this.padding,
    this.title,
    this.onCellTap,
    this.onTypeChange,
  }) : super(key: key);

  @override
  State<MultiTypeTableView> createState() => _MultiTypeTableViewState();
}

class _MultiTypeTableViewState extends State<MultiTypeTableView> {
  late int currentTypeIndex;
  late Map<String, TableType> types;

  @override
  void initState() {
    currentTypeIndex = widget.initialType;
    types = {
      for (TableType tableType in widget.types) tableType.name: tableType,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableView(
      models: widget.models,
      columns: widget.types[currentTypeIndex].columns,
      cellSetting: widget.types[currentTypeIndex].cellSetting,
      margin: widget.margin,
      padding: widget.padding,
      onRenderCell: widget.onRenderCell,
      avaliableModels: widget.types[currentTypeIndex].avaliableModels,
      title: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.title != null)
            Text(
              widget.title!.replaceAll(
                  '{currentType}', widget.types[currentTypeIndex].name),
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          const Gap(20),
          Flexible(
            child: DropDownView<int>(
              value: currentTypeIndex,
              items: List.generate(
                widget.types.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(
                    widget.types[index].name,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    currentTypeIndex = value;
                    if (widget.onTypeChange != null) {
                      widget.onTypeChange!(widget.types[currentTypeIndex]);
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
      onCellTap: widget.onCellTap,
    );
  }
}

class TableType<T> {
  final T value;
  final String name;
  final List<TableColumn> columns;
  final bool Function(Model model)? avaliableModels;
  final CellSetting? cellSetting;

  TableType({
    required this.value,
    required this.name,
    required this.columns,
    this.avaliableModels,
    this.cellSetting,
  });
}
