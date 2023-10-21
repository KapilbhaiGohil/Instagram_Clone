import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/User.dart';
import 'package:instagram_clone/Providers/User_Provider.dart';
import 'package:instagram_clone/resources/firebase_Storage_Methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key,required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating=false;
  int commentLen = 0;
  @override
  void initState(){
    super.initState();
    getCommentLen();
  }
  void getCommentLen()async{
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.snap['postid'])
          .collection('comment')
          .get();
      commentLen = snap.docs.length;
    }catch(err){
      showSnackBar(context, err.toString());
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final User user  = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
            Container(
              padding:  const EdgeInsets.symmetric(
                  vertical: 4,horizontal: 16).copyWith(right: 0),
                  child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.snap["ProfImage"]),

                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.snap['username']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    IconButton(
                        onPressed: (){
                          showDialog(context: context, builder: (context){
                            return Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete'
                                ]
                                  .map((e) => InkWell(
                                  onTap: ()async{
                                    await FireStoreMethods().deletePost(widget.snap['postid']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,horizontal: 16
                                    ),
                                    child: Text(e),
                                  ),
                                )).toList()
                              ),
                            );
                          });
                        },
                        icon: const Icon(Icons.more_vert),
                    ),
                  ],
              ),
              //image section

            ),
          GestureDetector(
            onDoubleTap: ()async{
              setState(() {
                isLikeAnimating = true;
              });
              await  FireStoreMethods().likePost(widget.snap['postid'],user.uid, widget.snap['likes']);
            },
            child:
              Stack(
                alignment: Alignment.center,
                children: [
                    SizedBox(
                    height: MediaQuery.of(context).size.height*0.35,
                    width: double.infinity,
                    child: Image.network(widget.snap['PostUrl'],fit: BoxFit.cover,),
                  ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds:200),
                      opacity: isLikeAnimating ? 1:0,
                      child: LikeAnimation(
                        child: const Icon(
                          Icons.favorite,
                          size: 120,color:
                          Colors.white,
                        ),
                        isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: (){
                          setState(() {
                            isLikeAnimating=false;
                          });
                      },
                  ),
                    )
                ],

              ),
          ),
          //like comment section
          Row(
            children: [
              LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                      onPressed: ()async{
                        await  FireStoreMethods().likePost(widget.snap['postid'],user.uid, widget.snap['likes']);
                      },
                      icon:
    widget.snap['likes'].contains(user.uid)?
                      Icon(

                        Icons.favorite,color: Colors.red,
                      )
                    :Icon(
                          Icons.favorite_border,
                    ),
                  ),
              ),
              IconButton(
                  onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>CommentScreen(snap: widget.snap))
                  ),
                  icon: Icon(Icons.comment_outlined)
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.share)),
              Expanded(child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(icon: Icon(Icons.bookmark_border),onPressed: (){},),
              ))
            ],
          ),
          //Description and no of cooment
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight:FontWeight.w800),
                  child: Text("${widget.snap['likes'].length} Likes",
                  style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            color: primaryColor,
                        ),
                      children: [
                        TextSpan(text: "${widget.snap['username']} ",style: TextStyle(fontWeight:FontWeight.bold)),
                        TextSpan(text: "${widget.snap['Description']}",)
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child:
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4,),
                      child: Text("${commentLen} comments",style: TextStyle(fontSize: 16,color: secondanaryColor),),
                    ),
                ),
                InkWell(
                  onTap: (){},
                  child:
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4,),
                    child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),style: TextStyle(fontSize: 16,color: secondanaryColor),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
