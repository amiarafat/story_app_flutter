import 'package:flutter/material.dart';
import 'package:story_app/db/db_helper.dart';
import 'package:story_app/main.dart';

enum StoryMode{
  Editing,
  Adding
}


class Story extends StatefulWidget {

  final StoryMode storyMode;
  final String sTitle;
  final String sBody;
  final int id;

  Story(this.storyMode,this.sTitle,this.sBody,this.id);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  bool _validateTitle  =false;
  bool _validateBody  =false;


  @override
  Widget build(BuildContext context) {

    _titleController.text = widget.sTitle;
    _textController.text = widget.sBody;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            widget.storyMode == StoryMode.Adding ? 'New Story' : 'Edit Story'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Flex(
          direction: Axis.vertical,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                errorText: _validateTitle ? 'Value Can\'t Be Empty' : null,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Story Name',
              ),
            ),
            SizedBox(
              height: 8,

            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                errorText: _validateBody ? 'Value Can\'t Be Empty' : null,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Short Story...',
              ),
              minLines: 8,
              maxLines: 20,
              autocorrect: false,

            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                StoryButton('Save',Colors.blue,(){

                  if(widget.storyMode == StoryMode.Adding){
                    saveStory();
                  }else if(widget.storyMode == StoryMode.Editing){
                    updateStory(widget.id);
                  }

                }),
                SizedBox(height: 8),
                StoryButton('Discard',Colors.grey,(){
                  Navigator.pop(context);
                }),
                SizedBox(height: 8),
               /* widget.storyMode == StoryMode.Editing ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryButton('Delete',Colors.red,(){
                    deleteStory(widget.id);
                    Navigator.pop(context);
                  }),
                ) : Container(),*/
              ],
            ),
          ],
        ),
      ),
    );

  }

  //Save TO DB
  void saveStory() async{

    if(_titleController.text.isEmpty ||  _textController.text.isEmpty){
      showInSnackBar("Please Insert Story Title and Story");

    }else{

      await DatabaseHelper.instance.insert(DatabaseHelper.tableStory, {
        DatabaseHelper.storyName : _titleController.text,
        DatabaseHelper.storyDetails : _textController.text

      });

      Navigator.pop(context,true);
    }
  }

  //Update TO DB
  Future<void> updateStory(int id) async {

    print(_titleController.text);

    if(_titleController.text.isEmpty ||  _textController.text.isEmpty){
      showInSnackBar("Please Insert Story Title and Story");

    }else{

      await DatabaseHelper.instance.updateStoryTable(DatabaseHelper.tableStory, {
        DatabaseHelper.storyName : _titleController.text,
        DatabaseHelper.storyDetails : _textController.text

      },id);

      Navigator.pop(context,true);
    }
  }

  //Delete ROW TO DB
  /*Future<void> deleteStory(int index) async {

    await DatabaseHelper.instance.deleteRow(DatabaseHelper.tableStory, index);
    Navigator.pop(context,true);
  }*/

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
}

class StoryButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  StoryButton(this._text,this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8)),
      onPressed:_onPressed
      ,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      color: _color,
      minWidth: 100,
      height: 44,
    );
  }


}
