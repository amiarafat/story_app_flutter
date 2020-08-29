import 'package:flutter/material.dart';
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

  List<Map<String,String>> storyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: ListView.builder(
          itemBuilder:(context,index){
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return Story(StoryMode.Editing);
                    }
                ));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30,bottom: 30,left: 14,right: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StoryTitle(storyList[index]['title']),
                      SizedBox(
                        height: 4,
                      ),
                      _StoryBody(storyList[index]['text']),
                    ],
                  ),
                ),
              ),
            );
          },
        itemCount: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context){
                return Story(StoryMode.Adding);
              }
          ));
        } ,
        label: Text("New Story"),
        icon: Icon(Icons.event_note),
      ),
    );
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
