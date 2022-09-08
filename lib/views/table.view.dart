import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/model.dart';
import '../src/theme.dart';

class StreamTableView extends StatelessWidget {
  final Stream<List<Model>> modelsStream;
  final List<TableColumn> columns;
  final CellSetting? cellSetting;
  final Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell;
  final EdgeInsets? margin, padding;
  final Widget? title;
  final bool Function(Model model)? avaliableModels;
  final Function(TableViewCell? cell, Model model)? onCellTap;

  const StreamTableView({
    Key? key,
    required this.modelsStream,
    required this.columns,
    this.cellSetting,
    this.onRenderCell,
    this.margin,
    this.padding,
    this.title,
    this.avaliableModels,
    this.onCellTap,
  }) : super(key: key);

  factory StreamTableView.textTitle(
    String title, {
    required Stream<List<Model>> modelsStream,
    required List<TableColumn> columns,
    CellSetting? cellSetting,
    Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool Function(Model model)? avaliableModels,
    Function(TableViewCell? cell, Model model)? onCellTap,
  }) {
    return StreamTableView(
      modelsStream: modelsStream,
      columns: columns,
      cellSetting: cellSetting,
      margin: margin,
      padding: padding,
      onRenderCell: onRenderCell,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: UIThemeColors.text2,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      avaliableModels: avaliableModels,
      onCellTap: onCellTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Flex(
        direction: Axis.vertical,
        children: [
          if (title != null) ...[title!, const Gap(10)],
          Flexible(
            child: StreamBuilder<List<Model>>(
              stream: modelsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(child: CircularProgressIndicator()),
                      const Gap(10),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: UIThemeColors.text2,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  );
                } else {
                  return SfDataGrid(
                    source: ModelDataSource(
                      onCellTap: onCellTap,
                      models: snapshot.data!,
                      colNames: List.generate(
                        columns.length,
                        (index) => columns[index].name,
                      ),
                      cellsSetting: cellSetting ?? CellSetting(),
                      onRenderCell: onRenderCell,
                      avaliableModels: avaliableModels,
                    ),
                    columns: List.generate(
                      columns.length,
                      (index) => GridColumn(
                        columnName: columns[index].name,
                        columnWidthMode: columns[index].columnWidthMode,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: UIThemeColors.cardBg,
                            border:
                                Border.all(color: UIColors.grey, width: 0.4),
                            borderRadius: BorderRadius.only(
                              topLeft: index == 0
                                  ? const Radius.circular(4)
                                  : Radius.zero,
                              topRight: index == columns.length - 1
                                  ? const Radius.circular(4)
                                  : Radius.zero,
                            ),
                          ),
                          child: Text(
                            columns[index].value,
                            style: TextStyle(
                              color: UIThemeColors.text2,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TableView extends StatelessWidget {
  final List<Model> models;
  final List<TableColumn> columns;
  final CellSetting? cellSetting;
  final Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell;
  final EdgeInsets? margin, padding;
  final Widget? title;
  final bool Function(Model model)? avaliableModels;
  final Function(TableViewCell? cell, Model model)? onCellTap;

  const TableView({
    Key? key,
    required this.models,
    required this.columns,
    this.cellSetting,
    this.onRenderCell,
    this.margin,
    this.padding,
    this.title,
    this.avaliableModels,
    this.onCellTap,
  }) : super(key: key);

  factory TableView.textTitle(
    String title, {
    required List<Model> models,
    required List<TableColumn> columns,
    CellSetting? cellSetting,
    Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool Function(Model)? avaliableModels,
    Function(TableViewCell? cell, Model model)? onCellTap,
  }) =>
      TableView(
        models: models,
        columns: columns,
        cellSetting: cellSetting,
        margin: margin,
        padding: padding,
        onRenderCell: onRenderCell,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: UIThemeColors.text2,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        avaliableModels: avaliableModels,
        onCellTap: onCellTap,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Flex(
        direction: Axis.vertical,
        children: [
          if (title != null) ...[title!, const Gap(10)],
          Flexible(
            child: SfDataGrid(
              source: ModelDataSource(
                models: models,
                colNames: List.generate(
                  columns.length,
                  (index) => columns[index].name,
                ),
                cellsSetting: cellSetting ?? CellSetting(),
                onRenderCell: onRenderCell,
                avaliableModels: avaliableModels,
                onCellTap: onCellTap,
              ),
              columns: List.generate(
                columns.length,
                (index) => GridColumn(
                  columnName: columns[index].name,
                  columnWidthMode: columns[index].columnWidthMode,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: UIThemeColors.cardBg,
                      border: Border.all(color: UIColors.grey, width: 0.4),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            index == 0 ? const Radius.circular(4) : Radius.zero,
                        topRight: index == columns.length - 1
                            ? const Radius.circular(4)
                            : Radius.zero,
                      ),
                    ),
                    child: Text(
                      columns[index].value,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModelDataSource extends DataGridSource {
  final List<Model> models;
  final Widget? Function(TableViewCell cell, int rowIndex)? onRenderCell;
  final Function(TableViewCell? cell, Model model)? onCellTap;

  ModelDataSource({
    required this.models,
    required List<String> colNames,
    required CellSetting cellsSetting,
    this.onRenderCell,
    this.onCellTap,
    bool Function(Model model)? avaliableModels,
  }) {
    _rows = [
      for (Model model in models)
        if (avaliableModels == null || avaliableModels(model))
          DataGridRow(
            cells: List<DataGridCell<TableViewCell>>.generate(
              colNames.length,
              (index) {
                var val = model.getValue(colNames[index]);
                return DataGridCell<TableViewCell>(
                  columnName: colNames[index],
                  value: TableViewCell(
                    val,
                    colNames[index],
                    renderData: val.runtimeType == DateTime
                        ? cellsSetting.dateTime
                        : cellsSetting.string,
                  ),
                );
              },
            ),
          )
    ];
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);
    List<DataGridCell<TableViewCell>> cells =
        row.getCells() as List<DataGridCell<TableViewCell>>;
    return DataGridRowAdapter(
      cells: List.generate(
        cells.length,
        (index) {
          return GestureDetector(
            onTap: onCellTap != null
                ? () => onCellTap!(cells[index].value, models[rowIndex])
                : null,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: rowIndex % 2 == 0
                    ? UIThemeColors.tableCellBg1
                    : UIThemeColors.tableCellBg2,
                border: const Border.symmetric(
                  vertical: BorderSide(
                    color: UIColors.grey,
                    width: 0.4,
                  ),
                ),
              ),
              child: (onRenderCell != null
                      ? onRenderCell!(cells[index].value!, rowIndex)
                      : null) ??
                  (cells[index].value!.render(rowIndex % 2 == 0)),
            ),
          );
        },
      ),
    );
  }
}

class TableColumn {
  final String value, name;
  final ColumnWidthMode columnWidthMode;

  TableColumn(
    this.value,
    this.name, {
    this.columnWidthMode = ColumnWidthMode.none,
  });
}

class TableViewCell {
  final dynamic value;
  final String colName;
  final RenderData? renderData;

  TableViewCell(this.value, this.colName, {this.renderData});

  Widget render(bool style2) {
    if (value.runtimeType == DateTime) {
      final dateTimeRnderData = renderData as DateTimeRnderData;
      return Text(
        DateFormat(
          dateTimeRnderData.dateFormat,
        ).format(value as DateTime),
        style: style2 ? dateTimeRnderData.style2 : dateTimeRnderData.style1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      final stringRnderData = renderData as StringRnderData;
      return Text(
        value != null ? value.toString() : '--',
        style: style2 ? stringRnderData.style2 : stringRnderData.style1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}

class RenderData<T> {
  final Map<String, T> _data;

  RenderData(this._data);

  Map<String, T> get data => _data;

  setData(String key, T data) {
    _data[key] = data;
  }
}

class StringRnderData extends RenderData<dynamic> {
  final TextStyle style1, style2;

  StringRnderData(this.style1, this.style2)
      : super({
          'style1': style1,
          'style2': style2,
        });
}

class DateTimeRnderData extends RenderData<dynamic> {
  final TextStyle style1, style2;
  final String dateFormat;

  DateTimeRnderData(
    this.style1,
    this.style2, {
    this.dateFormat = 'yyyy-MM-dd HH:mm:ss',
  }) : super({
          'style1': style1,
          'style2': style2,
          'dateFormat': dateFormat,
        });

  factory DateTimeRnderData.date({TextStyle? style1, TextStyle? style2}) =>
      DateTimeRnderData(
        style1 ?? CellSetting.defualtTextStyle1,
        style2 ?? CellSetting.defualtTextStyle2,
        dateFormat: 'yyyy-MM-dd',
      );
  factory DateTimeRnderData.time({TextStyle? style1, TextStyle? style2}) =>
      DateTimeRnderData(
        style1 ?? CellSetting.defualtTextStyle1,
        style2 ?? CellSetting.defualtTextStyle2,
        dateFormat: 'HH:mm',
      );
}

class CellSetting {
  late RenderData? string;
  late RenderData? dateTime;

  static TextStyle defualtTextStyle1 = TextStyle(
    color: UIThemeColors.tableCellFg1,
    fontSize: 16,
  );
  static TextStyle defualtTextStyle2 = TextStyle(
    color: UIThemeColors.tableCellFg2,
    fontSize: 16,
  );

  CellSetting({this.string, this.dateTime}) {
    string = string ??
        StringRnderData(
          defualtTextStyle1,
          defualtTextStyle2,
        );
    dateTime = dateTime ??
        DateTimeRnderData(
          defualtTextStyle1,
          defualtTextStyle2,
        );
  }
}
