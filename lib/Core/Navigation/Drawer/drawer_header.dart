import 'package:caresync_hms/Core/Navigation/Buttons/signin_button_type1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Widget drawerHeader(BuildContext context) {
  return DrawerHeader(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(FirebaseAuth.instance.currentUser != null)...[
          GestureDetector(
            onTap: () {
              //todo:
            },
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(
                      image: FirebaseAuth.instance.currentUser!.photoURL ?? '',
                      //?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgBhcplevwUKGRs1P-Ps8Mwf2wOwnW_R_JIA&usqp=CAU',
                      placeholder: kTransparentImage,
                    ),
                  ),
                ),
                const SizedBox(width: 14,),
                SizedBox(
                  width: 170,
                  child: Text(
                    FirebaseAuth.instance.currentUser!.displayName ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
        else...[
          signInUsingGoogleButtonType1(context),
        ],
        //const Expanded(child: SizedBox()),
        browseCareSync()
      ],
    ),
  );
}

Widget browseCareSync() {
  return const Padding(
    padding: EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black
          ),
        ),
        Text(
          'CareSync',
          style: TextStyle(
              fontSize: 21,

              fontWeight: FontWeight.w700,
              color: Colors.black
          ),
        ),
      ],
    ),
  );
}