import 'package:flutter/material.dart';

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
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
              minLines: 16,
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
