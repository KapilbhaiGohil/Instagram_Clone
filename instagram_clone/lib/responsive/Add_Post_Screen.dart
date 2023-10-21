import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Models/User.dart';
import 'package:instagram_clone/Providers/User_Provider.dart';
import 'package:instagram_clone/resources/firebase_Storage_Methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  TextEditingController _descriptionController = TextEditingController();
  bool isLoading= false;
  void postImage(String uid,String username,String profileImage)async{
    setState(() {
      isLoading= true;
    });
    try{
      String res = await FireStoreMethods().UploadPost(_descriptionController.text, _file!, uid, username,profileImage);
      setState(() {
        isLoading= false;
      });
      if(res=='success'){
        showSnackBar(context, "Posted!");
        clearImage();
      }else{
        showSnackBar(context, res);
      }
    }catch(err){
      setState(() {
        isLoading= false;
      });
        showSnackBar(context, err.toString());
    }
  }

  _selectImage(BuildContext context)async{
    return showDialog(context: context, builder: (context){
        return SimpleDialog(
            title: Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a Photo"),
                onPressed: ()async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file=file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose From Gallary"),
                onPressed: ()async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file=file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
        );
    });
  }
  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  void Dispose(){
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file==null ?Center(
      child: IconButton(
        icon: Icon(Icons.upload),
        onPressed: ()=>_selectImage(context),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: Text("Post To"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: ()=>postImage(user.uid,user.username,user.photoUrl),
            child: const Text(
                "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          isLoading?const LinearProgressIndicator():const Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),

              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],

          ),
        ],
      ),
    );
  }
}
