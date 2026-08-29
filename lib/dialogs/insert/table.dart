import 'package:flutter/material.dart' as legacy_material;
import 'package:flutter/services.dart';

import 'package:material_ui/material_ui.dart';

import 'package:provider/provider.dart';

import 'package:pluto_grid/pluto_grid.dart';

import '../../handlers/settings.dart';

class InsertTableDialog extends StatefulWidget
{
  const InsertTableDialog({super.key});

  @override
  State<InsertTableDialog> createState() => _InsertTableDialogState();

  static Future<String?> show(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const InsertTableDialog()
    );
  }
}

class _InsertTableDialogState extends State<InsertTableDialog> {
  int rowsRequested = 5;
  int columnsRequested = 5;

  TextEditingController rowController = TextEditingController(text: "5");
  TextEditingController columnController = TextEditingController(text: "5");

  late PlutoGridStateManager plutoGridStateManager;

  String getTableData(){
    try{
      // Ensure pluto grid saves data
      PlutoCell? plutoCurrentCell = plutoGridStateManager.currentCell;

      if(plutoCurrentCell!=null && plutoGridStateManager.isEditing){
        FocusScope.of(context).unfocus();
        final String? currentText = plutoGridStateManager.textEditingController!.text;
        if(currentText!=null){
          plutoGridStateManager.changeCellValue(plutoCurrentCell, currentText, force: true);
        }

        plutoGridStateManager.setEditing(false);
      }

      final rows = plutoGridStateManager.refRows;

      String data = "";
      bool addedSpacer = false;

      for(var row in rows){
        final cells = row.cells;
        for(var cell in cells.values){
          data += "|" + cell.value;
        }
        data += "|\n";

        // Add header seperator
        if(!addedSpacer){
          for(int i=0; i<columnsRequested; i++){
            data += "|-";
          }
          data += "|\n";
          addedSpacer = true;
        }
      }
      return data;
    }
    catch(e){
      return "$e";
    }
  }

  TextInputFormatter MinValueInputFormatter(value){
    return TextInputFormatter.withFunction(
      ((oldValue, newValue){
        if(newValue.text.isEmpty){
          return newValue;
        }
        else{
          final newInt = int.tryParse(newValue.text);
          if(newInt==null){
            return oldValue;
          }
          else{
            if(newInt<value){
              return oldValue;
            }
            else{
              return newValue;
            }
          }
        }
        return newValue;
      })
    );
  }

  @override
  Widget build(BuildContext context)
  {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = context.read<Settings>().settingsIsDarkMode;

    //Color colorPrimary = colorScheme.primary;

    final tableHeight = (45.0*rowsRequested) + 45.0 + 10.0;
    final tableMaxHeight = (MediaQuery.of(context).size.height * 0.8) - 200;

    final tableWidth = (200.0*columnsRequested) + 10.0;
    final tableMaxWidth = (MediaQuery.of(context).size.width * 0.8) - 10.0;

    return AlertDialog(
      title: Text("Insert Table"),
      clipBehavior: .hardEdge,
      contentPadding: .all(16),
      content: SizedBox(
        //height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(
              mainAxisSize: .min,
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Flexible(
                  child: TextField(
                    controller: columnController,
                    decoration: InputDecoration(
                      labelText: "Columns"
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      MinValueInputFormatter(1),
                    ],
                    maxLines: 1,
                    expands: false,
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextField(
                    controller: rowController,
                    decoration: InputDecoration(
                      labelText: "Rows",
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      MinValueInputFormatter(1),
                    ],
                    maxLines: 1,
                    expands: false,
                  )
                ),
                SizedBox(width: 16),
                IconButton.filled(
                  icon: Icon(Icons.check),
                  tooltip: "Generate table",
                  onPressed: (){
                    final rowsNo = int.tryParse(rowController.text);
                    final columnsNo = int.tryParse(columnController.text) ;

                    if(rowsNo!=null && columnsNo!=null){
                      if(rowsNo>0 && columnsNo>0){
                        setState(() {
                          rowsRequested = rowsNo;
                          columnsRequested = columnsNo;
                        });
                      }
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: tableHeight.clamp(100, tableMaxHeight),
              width: tableWidth.clamp(100, tableMaxWidth),
              child: MaterialUiCompatibilityBridge(
                child: legacy_material.Material(
                  child: PlutoGrid(
                    key: ValueKey("$rowsRequested x $columnsRequested"),
                    configuration: isDarkMode ? PlutoGridConfiguration.dark() : PlutoGridConfiguration(),
                    rows: List.generate(
                      rowsRequested,
                      (rowIndex){
                        final cells = <String,PlutoCell>{};

                        for(int columnIndex=0; columnIndex<columnsRequested; columnIndex++){
                          cells["Column_$columnIndex"] = PlutoCell(value: "");
                        }

                        return PlutoRow(cells: cells);
                      }
                    ),
                    columns: List.generate(
                      columnsRequested,
                      (columnIndex){
                        return PlutoColumn(
                          title: "Column ${columnIndex+1}",
                          field: "Column_$columnIndex",
                          type: .text(),
                        );
                      }
                    ),
                    onLoaded: (event){
                      plutoGridStateManager = event.stateManager;
                    },
                  ),
                )
              )
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          child: Text("Insert"),
          onPressed: (){
            if(rowsRequested>0 && columnsRequested>0){
              Navigator.of(context).pop(getTableData());
            }
            //Navigator.of(context).pop();
          },
        ),
        SizedBox(width: 16),
        OutlinedButton(
          child: Text("Close"),
          onPressed: (){
            Navigator.of(context).pop(null);
          },
        )
      ],
    );
  }
}
