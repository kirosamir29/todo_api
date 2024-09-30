import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(git 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey,
          ),
          height: 200,
          width: 350, //MediaQuery.of(context).size.width
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please, wait",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 16,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
