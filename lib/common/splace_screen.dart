import 'package:flat_finder/common/login_and_signup/login_screen.dart';
import 'package:flat_finder/database/firebase/authentication/authentication_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../landlord/bottom_navigation_landlord.dart';
import '../tenant/bottom_navigation_tenant.dart';


class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3),() async{
      final user = AuthService().getInstance().currentUser;   // get current user
      // check if current user is not null
      if(user != null){
        final accountType = await AuthService().getAccountType(user.uid);   // get account type

        // check account type and direct to the related screen
        if (accountType == "Renter") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationTenant()),
          );
        } else if (accountType == "Landlord") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationLandlord()),
          );
        }

      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png')
      ),
    );
  }
}
