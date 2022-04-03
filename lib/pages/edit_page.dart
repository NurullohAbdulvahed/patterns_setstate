import 'package:flutter/material.dart';
import 'package:patterns_setstate/services/log_service.dart';
import '../models/post_model.dart';
import '../services/http_service.dart';

//ignore: must_be_immutable
class EditPage extends StatefulWidget {
  static String id ="EditPage";
  Post? post;
   EditPage({Key? key, required this.post}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Post? oldPost;


  void _apiEditData() async{
    String title = titleController.text.toString().trim();
    String body = bodyController.text.toString().trim();
    if(widget.post != null){
      Post post = Post(id: widget.post!.id, title: title, body: body, userId: body.length);
      String? result = await Network.PUT(Network.API_UPDATE + widget.post!.id.toString(), Network.paramsUpdate(post));
      if(result != null) {
        if(mounted){
          Navigator.pop(context, result);
        }
      } else {
        Log.e("Error");
      }

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.post?.title ?? "No Data";
    bodyController.text = widget.post?.body ?? "No Data";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Post"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              _apiEditData();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              maxLines: 3,
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            TextField(
              maxLines: 10,
              controller: bodyController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Body",
              ),
            ),
          ],
        ),
      ),
    );

  }
}
