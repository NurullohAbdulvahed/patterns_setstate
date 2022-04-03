import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patterns_setstate/services/http_service.dart';
import 'package:patterns_setstate/services/log_service.dart';
import '../models/post_model.dart';
import 'create_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  static String id = "";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiPostList() {
    setState(() {
      isLoading = true;
    });
    Network.GET(Network.API_LIST, Network.paramsEmpty()).then((response) => {
     // Log.d(response!),
      _showResponse(response!),
    });
  }

  void _showResponse(String response) {
    List<Post> list = Network.parsePostList(response);
    items.clear();
    setState(() {
      isLoading = false;
      items = list;
    });

  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    setState(() {
      if (response != null) {
        items.remove(post);
      }
      isLoading = false;
    });
  }

  void goToCreatePage() async{
   String result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreatePage()));
    setState(() {
      items.add(Network.parsePost(result));
    });

  }


  void goToEditPage(Post post) async{
    String result =await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPage(post: post,)));
    setState(() {
      Post newPost = Network.parsePost(result);
      items[items.indexWhere((element) => element.id == newPost.id)] = newPost;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Set State"),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                return itemOfPost(items[index]);
              },
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            goToCreatePage();
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget itemOfPost(Post post) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              goToEditPage(post);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane:  ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (BuildContext context) {
              _apiPostDelete(post);
            },
          ),
        ],
      ),
      child: Container(
        padding:const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title.toUpperCase(),
              style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}
