import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget
{
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {

  MenuController menuController = MenuController();
  TextEditingController editorController = TextEditingController();

  @override initState(){
    super.initState();
  }

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("<File Name>"),
        leading: MenuAnchor(
          controller: menuController,
          menuChildren: [
            MenuItemButton(
              child: Text("New"),
              onPressed: (){
                menuController.close();
              },
            ),
            MenuItemButton(
              child: Text("Open"),
              onPressed: (){
                menuController.close();
              },
            ),
            Divider(),
            MenuItemButton(
              child: Text("Save"),
              onPressed: (){
                menuController.close();
              },
            ),
            MenuItemButton(
              child: Text("Save As..."),
              onPressed: (){
                menuController.close();
              },
            ),
          ],
          child: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: (){
              menuController.open();
            }
          ),
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:EdgeInsetsGeometry.all(16),
              child: TextField(
                controller: editorController,

                maxLines: null,
                enableInteractiveSelection: true,
                keyboardType: .multiline,
                autofocus: true,
                decoration: null,

                selectionWidthStyle: .tight,

                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white
                ),
                cursorColor: Colors.red,
              )
            )
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text("...")
                ),
                Divider(),
                Text("...")
              ],
            )
          )
        ],
      )
    );
  }
}
