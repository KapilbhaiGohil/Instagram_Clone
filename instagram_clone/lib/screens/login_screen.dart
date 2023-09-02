import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController  = TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
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
              //text input for mail
              const SizedBox(height: 64,),
              TextFieldInput(textEditingController: _emailController, hintText: "Enter Your Email", textInputType: TextInputType.emailAddress),
              //text input for password
              const SizedBox(height: 25,),
              TextFieldInput(textEditingController: _passwordController, hintText: "Enter The Password", textInputType: TextInputType.text,isPass: true,),
              const SizedBox(height: 24,),
              //text button
              InkWell(
                child: Container(
                  child: const Text("Login"),
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
                    child:const Text("Don't Have Account? "),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      child:const Text("Sing up",style: TextStyle(fontWeight: FontWeight.bold),),
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
