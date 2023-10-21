import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/User.dart';
import 'package:instagram_clone/Providers/User_Provider.dart';
import 'package:instagram_clone/resources/firebase_Storage_Methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';
class CommentScreen extends StatefulWidget {
  final snap;
  //const CommentScreen({super.key,required this.snap});
  const CommentScreen({Key? key,required this.snap}):super(key: key);
  @override
  State<CommentScreen> createState() => _CommentScreenState();


}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose(){
    super.dispose();
    commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').doc(widget.snap['postid']).collection('comment').orderBy('datePublished',descending: false).snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index)=>CommentCard(
              snap:snapshot.data!.docs[index].data()
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  await FireStoreMethods().postComment(widget.snap['postid'],commentController.text,user.uid, user.username, user.photoUrl);
                  setState(() {
                    commentController.text = "";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                  child: Text("Post",
                    style: TextStyle(
                      color: Colors.blueAccent
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
