import 'package:flutter/material.dart';
import 'package:patterns_setstate/services/http_service.dart';
import 'package:patterns_setstate/services/log_service.dart';


import '../models/post_model.dart';



class CreatePage extends StatefulWidget {
  static String id = "CreatePage";
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();


  void _apiCreatePost() async{
    String title = titleController.text.toString().trim();
    String body = bodyController.text.toString().trim();
    Post post =Post(title: title, body: body, userId: body.hashCode);
    var result = await Network.POST(Network.API_CREATE, Network.paramsCreate(post));
    if(result != null){
      if(mounted) {
        Navigator.pop(context,result);
      }
    }
    else{
      Log.e("Something went wrong");
    }
    //Log.d(result!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              _apiCreatePost();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
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
