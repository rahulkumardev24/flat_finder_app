import 'package:flat_finder/common/login_and_signup/login_screen.dart';
import 'package:flat_finder/database/firebase/authentication/authentication_helper.dart';
import 'package:flat_finder/utils/custom_text_style.dart';
import 'package:flat_finder/widgets/custom_text_field.dart';
import 'package:flat_finder/widgets/full_width_button.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05,),
            Image.asset("assets/images/logo.png", height: screenHeight * 0.3,),
            SizedBox(height: screenHeight * 0.05,),
            Container(
              width: double.infinity,
              height: screenHeight * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5), spreadRadius: 5)],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text("Forgot Password ?", style: myTextStyle36(fontFamily: "Poppins-Semibold"),),
                    const SizedBox(height: 10,),
                    Text("Don't worry... we are here to help you", style: myTextStyle15(),),
                    const SizedBox(height: 20,),
                    CustomTextField(label: "Enter Email", textController: emailController),
                    const SizedBox(height: 10,),
                    Text("make sure you have entered a registered email", style: myTextStyle12(),),
                    const SizedBox(height: 30,),
                    FullWidthButton(text: "Send link", onPressed: () async{
                      if(emailController.text.isNotEmpty){
                        String? isSent = await AuthService().resetPassword(emailController.text.toString());
                        if(isSent != null){
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isSent)));
                         emailController.clear();
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Something went wrong"))
                          );
                          emailController.clear();
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter registered email"),));
                      }
                    })

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
