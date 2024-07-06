import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whiskr/model/profile.dart';

class ProfileDetailsPage extends StatelessWidget {
  final ProfileModel profile;
  const ProfileDetailsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items: profile.photos.map((e) => Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(e),
                    fit: BoxFit.cover,
                  ),
                ),
              )).toList(), options: CarouselOptions(
                height: 300,
                viewportFraction: 1,
                autoPlay: true
              )),
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                   gradient: LinearGradient(
            colors: [
            Colors.blue.withOpacity(0.2),  
            Colors.black.withOpacity(0.7), 
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
                ),
              )
            ],
          ),
         const SizedBox(height: 12,),
          Text(profile.name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        const  SizedBox(height: 12,),
          Text(profile.bio,style:const  TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
        const  SizedBox(height: 12,),
          Text(profile.dob.toString(),style:const  TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
         const SizedBox(height: 12),
          Text(profile.type.name,style:const  TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
        const  SizedBox(height: 12,),
        ElevatedButton(onPressed: (){}, child: const Text("Start Chat"))
        ],
      ),
    );
  }
}
