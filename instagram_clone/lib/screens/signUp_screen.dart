import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  final TextEditingController _usernameController  = TextEditingController();
  final TextEditingController _bioController  = TextEditingController();
  Uint8List? _image;
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  void selectImage()async{
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 34),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 1,),
              // svg image
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 64,
              ),
              const SizedBox(height: 64,),
              Stack(
                children: [
                  _image!=null?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  ):
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcU50X1UOeDaphmUyD6T8ROKs-HjeirpOoapiWbC9cLAqewFy1gthrgUTB9E7nKjRwOVk&usqp=CAU"),
                  ),
                  Positioned(child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                    color: Colors.white70,
                  ),
                    bottom: -10,left: 80,),
                ],
              ),
              const SizedBox(height: 24,),
              //text input for the usename
              TextFieldInput(textEditingController: _usernameController, hintText: "Enter Your Username", textInputType: TextInputType.text,),
              //text input for mail
              const SizedBox(height: 24,),
              TextFieldInput(textEditingController: _emailController, hintText: "Enter Your Email", textInputType: TextInputType.emailAddress),
              //text input for password
              const SizedBox(height: 24,),
              TextFieldInput(textEditingController: _passwordController, hintText: "Enter The Password", textInputType: TextInputType.text,isPass: true,),
              const SizedBox(height: 24,),
              //text input for the bio
              TextFieldInput(textEditingController: _bioController, hintText: "Enter Your Bio", textInputType: TextInputType.text),
              const SizedBox(height: 24,),
              //text button
              InkWell(
                onTap: ()async{
                  String res = await AuthMethods().signUpUser(email: _emailController.text, password: _passwordController.text, username: _usernameController.text, bio: _bioController.text,file: _image!);
                  // print(res);
                },
                child: Container(
                  child: const Text("Sign Up"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              //transitioning to the sing up
              Flexible(child: Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child:const Text("Alread Registered? "),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      child:const Text("Log In",style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
