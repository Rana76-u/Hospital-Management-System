import 'package:flutter/material.dart';
import '../Theme/app_color.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String fieldName;

  const CustomInputField({
    super.key,
    required this.inputController,
    required this.fieldName,
  });


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,),
        Text(
          fieldName,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black.withValues(alpha: 0.9)),
        ),
        const SizedBox(height: 4,),
        Container(
          height: 50,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withValues(alpha: 0.1)),
          ]),
          child: TextField(

            controller: inputController,
            onChanged: (value) {
              //Do something wi
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              //label: Text(fieldName),
              //labelStyle: TextStyle(color: AppColor.primaryColorBlue,),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: Colors.blue.shade50,
              hintText: "Input $fieldName",
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.75)),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primaryColorBlue, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.secondaryColorLightGray, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ) ,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primaryColorBlue, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}