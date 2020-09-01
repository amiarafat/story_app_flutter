import 'package:flutter/material.dart';
import 'package:story_app/db/db_helper.dart';
import 'package:story_app/story.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  List<Map<String,dynamic>> storyList;
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllStory();

  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //getAllStory();
    }
    print(state);
  }

  @override
  Widget build(BuildContext context) {

    if(storyList == null){
      storyList = List<Map<String,dynamic>>();
      getAllStory();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: ListView.builder(
          itemBuilder:(context,index){
            return GestureDetector(
              onTap: (){
                navigateDetail(StoryMode.Editing);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30,bottom: 30,left: 14,right: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StoryTitle(storyList[index][DatabaseHelper.storyName]),
                      SizedBox(
                        height: 4,
                      ),
                      _StoryBody(storyList[index][DatabaseHelper.storyDetails]),
                    ],
                  ),
                ),
              ),
            );
          },
        itemCount: count,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:() async {

          navigateDetail(StoryMode.Adding);
        } ,
        label: Text("New Story"),
        icon: Icon(Icons.event_note),
      ),
    );
  }

  void getAllStory() async{

    storyList = await DatabaseHelper.instance.queryAll(DatabaseHelper.tableStory);
    debugPrint("list: " + storyList.toString());
    count = storyList.length;
    setState(() {


    });
  }

   /*saveStory() async {
    await DatabaseHelper.instance.insert(DatabaseHelper.tableStory, {
      DatabaseHelper.storyName : "First Story",
      DatabaseHelper.storyDetails : "Story Body"

    });

    debugPrint("Hello");
  }*/

   void navigateDetail(StoryMode adding) async{

   bool result =  await Navigator.of(context).push(MaterialPageRoute(
         builder: (context){
           return Story(adding);
         }
     ));

   if(result == true){
     getAllStory();
   }
   }
}

class _StoryTitle extends StatelessWidget {
  final String _title;

  _StoryTitle(this._title);


  @override
  Widget build(BuildContext context) {
    return  Text(
      _title,
      style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),
    );
  }
}

class _StoryBody extends StatelessWidget {
  final String _text;

  _StoryBody(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        color: Colors.grey.shade600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
