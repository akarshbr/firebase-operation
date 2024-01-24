import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_operation/firebase_phone_auth/firebase_phone_home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAHPbvuMDqhMP8ynSpvAXVbFJ5-MhZIwqM",
          appId: "1:486936459036:android:25651abe4e4cdcdcddecd9",
          messagingSenderId: "",
          projectId: "fir-operation-baa1e",
          storageBucket: "fir-operation-baa1e.appspot.com"));
  runApp(MaterialApp(home: FirebasePhoneAuth()));
}

class FirebasePhoneAuth extends StatefulWidget {
  const FirebasePhoneAuth({super.key});

  @override
  State<FirebasePhoneAuth> createState() => _FirebasePhoneAuthState();
}

class _FirebasePhoneAuthState extends State<FirebasePhoneAuth> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    String verificationID;
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Phone Authenticator", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Phone number",
                        border: OutlineInputBorder(borderSide: BorderSide())),
                  ),
                ),
                MaterialButton(
                    onPressed: () => sendOtp(),
                    color: Colors.blueGrey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Text("Send OTP"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "OTP",
                        border: OutlineInputBorder(borderSide: BorderSide())),
                  ),
                ),
                MaterialButton(
                    onPressed: () => confirmOTP(otpController.text.toString()),
                    color: Colors.blueGrey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Text("Confirm OTP"))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendOtp() async {
    String phoneNumber = "+91 ${phoneController.text.toString().trim()}";
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  Future<void> confirmOTP(String otpController) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: _verificationCode!, smsCode: otpController);
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FirebasePhoneHome()));
      });
    } catch (e) {
      print(e);
    }
  }
}
