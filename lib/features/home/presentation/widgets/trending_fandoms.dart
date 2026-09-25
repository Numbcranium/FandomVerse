import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techwiz7_starter/features/home/presentation/widgets/trending_fandom_card.dart';
import 'package:techwiz7_starter/features/home/presentation/widgets/trending_fandom_filter.dart';

class TrendingFandoms extends StatefulWidget {
  const TrendingFandoms({
    super.key,
  });

  @override
  State<TrendingFandoms> createState() =>
      _TrendingFandomsState();
}

class _TrendingFandomsState extends State<TrendingFandoms> {

  // calling firebase for the data  / connecting it to the flutter code
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This stores the category the user currently selected
  String selectedCategory = 'All';

  // FIREBASE ====================
  Stream<QuerySnapshot<Map<String, dynamic>>> getFandoms() {
    return _firestore
        // it goes to the collection in firestore collection name fandoms
        .collection('fandoms')
        // this gets the data from the firebase
        .snapshots();
  }

  // FILTER FIREBASE DATA

  List<QueryDocumentSnapshot<Map<String, dynamic>>> filterFandoms(
      List<QueryDocumentSnapshot<Map<String, dynamic>>>
      docs,
      ) {
    if (selectedCategory == 'All') {
      return docs;
    }

    return docs.where((doc) {
      final data = doc.data();

      final category =
          data['category']
              ?.toString()
              .trim()
              .toLowerCase() ??
              '';

      return category ==
          selectedCategory
              .trim()
              .toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF0B0A24),

      // ========================================
      // APP BAR
      // ========================================

      appBar: AppBar(
        backgroundColor:
        const Color(0xFF0B0A24),

        elevation: 0,
        // for the back button
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        // the app title
        title: const Text(
          'Trending Fandoms',

          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      // BODY ---------------

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getFandoms(),

        builder: (context, snapshot) {

          // LOADING when you click the category of the filter

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // ERROR if it did not connect to the firestore

          if (snapshot.hasError) {
            return const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),

                child: Text(
                  'Unable to load Trending fandoms, Try again later',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }


          // FIREBASE DOCUMENTS
          // each document contains its ID and its fields

          final docs = snapshot.data?.docs ?? []; // for any error

          // FILTERED FANDOMS


          final fandoms = filterFandoms(docs);


          // CONTENT --------------------------------------


          return SafeArea(
            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // FILTER

                  const SizedBox(
                    height: 10,
                  ),

                  TrendingFandomFilter(
                    selectedCategory:
                    selectedCategory,

                    onCategorySelected:
                        (category) {
                      setState(() {
                        selectedCategory =
                            category;
                      });
                    },
                  ),


                  // SPACE BEFORE CARDS


                  const SizedBox(
                    height: 20,
                  ),

                  // FANDOM CARDS


                  if (fandoms.isEmpty)

                    const Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),

                      child: Center(
                        child: Text(
                          'No fandoms found',

                          style: TextStyle(
                            color:
                            Colors.white54,
                          ),
                        ),
                      ),
                    )

                  else

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child:
                      ListView.separated(
                        shrinkWrap: true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        itemCount:
                        fandoms.length,

                        separatorBuilder:
                            (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        // displaying the cards in the screen and the data you want
                        itemBuilder:
                            (context, index) {

                          final doc =
                          fandoms[index];

                          final data =
                          doc.data();

                          return TrendingFandomCard(
                            fandomId:
                            doc.id,

                            name:
                            data['name']
                                ?.toString() ??
                                '',

                            image:
                            data['image']
                                ?.toString() ??
                                '',

                            category:
                            data['category']
                                ?.toString() ??
                                '',
                          );
                        },
                      ),
                    ),

                  // BOTTOM SPACE

                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}