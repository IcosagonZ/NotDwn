import 'package:material_ui/material_ui.dart';

// Pages
import 'editor.dart';

class StartPage extends StatefulWidget
{
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding:EdgeInsetsGeometry.all(16),
        child: Column(
          spacing: 10,
          children:[
            Card.filled(
              clipBehavior: .hardEdge,
              child: ListTile(
                title: Text("New file"),
                subtitle: Text("Create a new file"),
                leading: Icon(Icons.create),

                onTap:(){
                  print("ACTION: Create new file");

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context){
                        return EditorPage();
                      }
                    ),
                  );
                },
              ),
            ),

            Card.filled(
              clipBehavior: .hardEdge,
              child: ListTile(
                title: Text("Open file"),
                subtitle: Text("Open a existing file"),
                leading: Icon(Icons.file_open),

                onTap:() => {
                  print("ACTION: Open existing file")
                },
              ),
            ),

            Card.filled(
              clipBehavior: .hardEdge,
              child: ListTile(
                title: Text("Setting"),
                subtitle: Text("Tweak appearance or functionality"),
                leading: Icon(Icons.settings),

                onTap:() => {
                  print("ACTION: Open settings")
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
