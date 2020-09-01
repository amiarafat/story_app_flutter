import 'package:flutter/material.dart';
import 'package:story_app/db/db_helper.dart';
import 'package:story_app/main.dart';

enum StoryMode{
  Editing,
  Adding
}


class Story extends StatefulWidget {

  final StoryMode storyMode;

  Story(this.storyMode);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  bool _validateTitle  =false;
  bool _validateBody  =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.storyMode == StoryMode.Adding ? 'New Story' : 'Edit Story'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

                  print("btn pressed");
                  saveStory();

                }),
                SizedBox(height: 8),
                StoryButton('Discard',Colors.grey,(){
                  Navigator.pop(context);
                }),
                SizedBox(height: 8),

                widget.storyMode == StoryMode.Editing ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryButton('Delete',Colors.red,(){
                    Navigator.pop(context);
                  }),
                ) : Container(),
              ],
            ),
          ],
        ),
      ),
    );

  }

  void saveStory() async{

    print("btn pressed");

    /*_titleController.text.isEmpty ? _validateTitle = true : _validateTitle = false;
    _textController.text.isEmpty ? _validateBody = true : _validateBody = false;

    print(_titleController.text +"---"+_textController.text);

    if( _titleController.text.isNotEmpty || _textController.text.isEmpty){

    }else{

      int i = await DatabaseHelper.instance.insert(DatabaseHelper.tableStory, {
        DatabaseHelper.storyName : _titleController.text,
        DatabaseHelper.storyDetails : _textController.text

      });

      print("Id is $i");

    }*/
    await DatabaseHelper.instance.insert(DatabaseHelper.tableStory, {
      DatabaseHelper.storyName : _titleController.text,
      DatabaseHelper.storyDetails : _textController.text

    });

    Navigator.pop(context,true);


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
