import 'package:cafe_app1/HomeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cafeScreen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
         //   mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Padding(padding:        EdgeInsets.only(top: 100)),       
              Text(
                'Enjoy every sip with rich coffee  \n the  finest of  flavours',
                style: TextStyle(
                  fontSize: 24,
                  
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
           //   SizedBox(height: 20),
              const  Spacer(),
              Text('The best  of  ist  kind  you  can ever  get with\n  exquisite  taste and  quality  flowers.',style: TextStyle(color: Colors.white  ,fontSize: 14),),
              SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
               child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30),


                ),
                child:
                 ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                child: Text('Get Started',style: TextStyle(color: Colors.white),
                )

                ),
               )
                
              ),
              SizedBox( height: 20)
            
            ],

        ),
        )
      ),
    );
  }
}
