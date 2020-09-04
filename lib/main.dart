import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/db/db_helper.dart';
import 'package:story_app/story.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        title: Text('Story App'),
      ),
      body: ListView.builder(
          itemBuilder:(context,index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 16,bottom: 16,left: 12,right: 12),
                /*child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StoryTitle(storyList[index][DatabaseHelper.storyName]),
                    SizedBox(
                      height: 4,
                    ),
                    _StoryBody(storyList[index][DatabaseHelper.storyDetails]),
                  ],
                ),*/
                child: ListTile(
                  onTap: (){
                    navigateDetail(StoryMode.Editing,storyList[index][DatabaseHelper.storyName],storyList[index][DatabaseHelper.storyDetails],storyList[index][DatabaseHelper.storyId]);
                  },
                  contentPadding: const EdgeInsets.only(left: 4,right: 4),
                  title: _StoryTitle(storyList[index][DatabaseHelper.storyName]),
                  subtitle: _StoryBody(storyList[index][DatabaseHelper.storyDetails]),
                  leading: Icon(
                    Icons.event_note,
                    size: 36,
                    color: Colors.blue,
                  ),
                  trailing: GestureDetector(
                    onTap: (){
                      deleteStory(storyList[index][DatabaseHelper.storyId]);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
        itemCount: count,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:() async {

          navigateDetail(StoryMode.Adding,"","",null);
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

  void navigateDetail(StoryMode adding,String title,String body, int storyId) async{

   bool result =  await Navigator.of(context).push(MaterialPageRoute(
         builder: (context){
           return Story(adding,title,body,storyId);
         }
     ));

   if(result == true){
     getAllStory();
   }
   }

  Future<void> deleteStory(int indexId) async {
    await DatabaseHelper.instance.deleteRow(DatabaseHelper.tableStory, indexId);
    getAllStory();
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
          color: Colors.black54,
          fontSize: 20,
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
        fontSize: 14,
        color: Colors.grey.shade500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
