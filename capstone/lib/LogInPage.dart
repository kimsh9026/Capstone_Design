import 'package:flutter/material.dart';
import 'package:capstone/bloc_codes/BlocProvider.dart';
import 'package:capstone/fire_base_codes/fire_auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LogInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("Images/LoginUI/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
            children: [
              Container(margin: EdgeInsets.only(top: 117.0)),
              Container(
                width: 120.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("Images/LoginUI/trabuddyIcon.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(margin: EdgeInsets.only(top: 30.0)),
              Container(
                margin: EdgeInsets.only(left: 65.0, right: 65.0),
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () {
                    FireAuthProvider().authenticate() ;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65.0, right: 65.0),
                child: SignInButton(
                  Buttons.Facebook,
                  text: "Sign up with Facebook",
                  onPressed: () {
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65.0, right: 65.0),
                child: RaisedButton(
                  child: Text('Sign out with Google'),
                  onPressed: (){
                    FireAuthProvider().signOut() ;
                  }
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 60.0, top: 10.0),
                child: Text(
                  '이메일/비밀번호가 기억나지 않으세요?',
                  style: new TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60.0, top:20.0),
                child: Row(
                children: [
                  Container(
                    width: 120.0,
                    height: 30.0,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("Images/LoginUI/회원가입.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                      width: 120.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("Images/LoginUI/Login.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(margin: EdgeInsets.only(top: 67.0),),
            ],
          ),
      );
    }
}