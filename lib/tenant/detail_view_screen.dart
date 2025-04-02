import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_finder/common/chat_screen.dart';
import 'package:flat_finder/common/profile_screen.dart';
import 'package:flat_finder/landlord/bottom_navigation_landlord.dart';
import 'package:flat_finder/tenant/bottom_navigation_tenant.dart';
import 'package:flat_finder/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/colors.dart';

class DetailViewScreen extends StatefulWidget {
  final List<XFile> media;
  final String title;
  final String location;
  final String rent;
  final XFile dp;
  final String desc;
  final String type;
  final String bedroom;
  final String bathroom;
  final String furnishingStatus;
  final String allowed;
  final String floor;
  final String securityBill;
  final String availability;
  final String? electricity;
  final String? water;
  final String? cleaning;
  final String propertyId;

  const DetailViewScreen(
      {Key? key,
      required this.media,
      required this.title,
      required this.location,
      required this.rent,
      required this.dp,
      required this.desc,
      required this.type,
      required this.bedroom,
      required this.bathroom,
      required this.furnishingStatus,
      required this.allowed,
      required this.floor,
      required this.availability,
      this.electricity,
      this.water,
      this.cleaning,
      required this.securityBill,
      required this.propertyId})
      : super(key: key);

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  // State variable to track the selected image
  late XFile selectedImage;

  // To store user details
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    // Fetch user details for the property
    getUserDetails(widget.propertyId);
    // Initialize the main image
    selectedImage = widget.media[0];
  }

// Fetch owner details using ownerId, not propertyId
  Future<void> getUserDetails(String propertyId) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .get();
    if (userDoc.exists) {
      setState(() {
        userData = userDoc.data();
      });
    } else {
      setState(() {
        userData = {};
      });
    }
  }

  ///----------------------- here we use media query -------------------------///
  MediaQueryData? mqData;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyIconButton(
              mIcon: Icons.arrow_back_ios_rounded,
              onPress: () {
                Navigator.pop(context);
              }),
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ///--------------------------- Display the main image
            SizedBox(
              width: double.infinity,
              height: 400,
              child: Image.network(
                selectedImage.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
                },
              ),
            ),
            const SizedBox(height: 10),

            /// ------------------------ GRID VIEW IMAGE ---------------------///
            SizedBox(
              height: mqData!.size.height * 0.11,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 11),
                  itemCount: widget.media.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        /// ------------------Update the main image when click the image
                        setState(() {
                          selectedImage = widget.media[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: selectedImage == widget.media[index]
                              ? [
                                  const BoxShadow(
                                      color: Colors.black, blurRadius: 3)
                                ]
                              : null,
                          border: Border.all(
                            color: selectedImage == widget.media[index]
                                ? Colors.green
                                : Colors.transparent,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.media[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Other property details
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 30,
                            color: AppColors().darkGreen,
                            fontFamily: "Poppins-Semibold",
                          ),
                        ),
                        // Location and rent
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/location_outlined.svg",
                                width: 15,
                                height: 25),
                            const SizedBox(width: 7),
                            Text(
                              widget.location,
                              style: TextStyle(
                                  color: AppColors().darkGrey,
                                  fontFamily: "Poppins-Semibold"),
                            ),
                            const Spacer(),
                            Text("Rent - ₹${widget.rent}")
                          ],
                        ),

                        const Divider(thickness: 2),

                        ///--------------------- user post profile----------------------///
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: userData != null &&
                                      userData!['profileImage'] != null
                                  ? NetworkImage(userData!['profileImageUrl'])
                                  : FileImage(File(widget.dp.path))
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              userData != null && userData!['name'] != null
                                  ? userData!['name']
                                  : "Rahul Kumar ",
                              style: TextStyle(
                                  color: AppColors().darkGreen,
                                  fontFamily: "Poppins-Semibold",
                                  fontSize: 16),
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to user profile screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      userId: widget.propertyId,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors().green70),
                                side: WidgetStateProperty.all(BorderSide(
                                    color: AppColors().darkGreen, width: 2)),
                              ),
                              child: Row(
                                children: [
                                  Text("View",
                                      style: TextStyle(
                                          color: AppColors().darkGreen,
                                          fontFamily: "Poppins-Semibold")),
                                  Icon(Icons.keyboard_arrow_right,
                                      color: AppColors().darkGreen),
                                ],
                              ),
                            )
                          ],
                        ),

                        const Divider(thickness: 2),
                        // Details section
                        Text(
                          "Details",
                          style: TextStyle(
                              color: AppColors().darkGreen,
                              fontSize: 25,
                              fontFamily: "Poppins-Semibold"),
                        ),
                        Text(widget.desc),
                        // Additional property details
                        Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("TYPE"),
                                Text("BEDROOM"),
                                Text("BATHROOM"),
                                Text("FURNISHING STATUS"),
                                Text("WHO'S ALLOWED"),
                                Text("FLOOR NO"),
                                Text("SECURITY MONEY"),
                                Text("ELECTRICITY BILL"),
                                Text("WATER BILL"),
                                Text("CLEANING"),
                                Text("AVAILABLE FROM"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("    :   ${widget.type}"),
                                Text("    :   ${widget.bedroom}"),
                                Text("    :   ${widget.bathroom}"),
                                Text("    :   ${widget.furnishingStatus}"),
                                Text("    :   ${widget.allowed}"),
                                Text("    :   ${widget.floor}"),
                                Text("    :   ${widget.securityBill}"),
                                Text(
                                    "    :   ${widget.electricity?.isEmpty ?? true ? "000" : widget.electricity}"),
                                Text(
                                    "    :   ${widget.water?.isEmpty ?? true ? "000" : widget.water}"),
                                Text(
                                    "    :   ${widget.cleaning?.isEmpty ?? true ? "000" : widget.cleaning}"),
                                Text("    :   ${widget.availability}"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        /// -------------------------- Chat Button ---------------------------///
                        // Chat and Direction buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Redirect user to the landlord's chat screen
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavigationTenant(
                                                  selectedIndex: 1,
                                                )));
                                  },
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11))),
                                    side: WidgetStateProperty.all(BorderSide(
                                        color: AppColors().darkBlue, width: 2)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/icons/chat.svg",
                                          width: 30, height: 30),
                                      const SizedBox(width: 10),
                                      Text("Chat",
                                          style: TextStyle(
                                              color: AppColors().blue,
                                              fontFamily: "Poppins-Semibold",
                                              fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Redirect user to Google Maps with property location
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        AppColors().blue),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11))),
                                    side: WidgetStateProperty.all(BorderSide(
                                        color: AppColors().darkBlue, width: 2)),
                                  ),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Transform.translate(
                                          offset: const Offset(-10, 0),
                                          child: const Icon(Icons.directions,
                                              color: Colors.white, size: 30),
                                        ),
                                        ///---------------DIRECTION BUTTON-----------------///
                                        InkWell(
                                          onTap: (){
                                            _openGoogleMaps(widget.location) ;

                                          },
                                          child: const Text("Direction",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Poppins-Semibold",
                                                  fontSize: 20)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                ))
          ]),
        ),
      ),
    );
  }
  ///  Open Google Maps with Navigation
  Future<void> _openGoogleMaps(String cityName) async {
    // String googleUrl = "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    String googleUrl = "https://www.google.com/maps/dir/?api=1&destination=$cityName";
    Uri uri = Uri.parse(googleUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open Google Maps";
    }
  }
}
