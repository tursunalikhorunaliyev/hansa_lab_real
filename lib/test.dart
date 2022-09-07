import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
     
              Expanded(
                child: MaterialButton(onPressed: (){
              
                },
                color: Colors.red,
                child: const  Text("Click me"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}