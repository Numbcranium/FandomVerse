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

class _TrendingFandomsState
    extends State<TrendingFandoms> {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String selectedCategory = 'All';

  // ==========================================
  // FIREBASE
  // ==========================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  getFandoms() {
    return _firestore
        .collection('fandoms')
        .snapshots();
  }

  // ==========================================
  // FILTER FIREBASE DATA
  // ==========================================

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
  filterFandoms(
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

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'Trending Fandoms',

          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================
      // BODY
      // ========================================

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: getFandoms(),

        builder: (context, snapshot) {

          // ======================================
          // LOADING
          // ======================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // ======================================
          // ERROR
          // ======================================

          if (snapshot.hasError) {
            return const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),

                child: Text(
                  'Unable to load trending fandoms',

                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }

          // ======================================
          // FIREBASE DOCUMENTS
          // ======================================

          final docs =
              snapshot.data?.docs ?? [];

          // ======================================
          // FILTERED FANDOMS
          // ======================================

          final fandoms =
          filterFandoms(docs);

          // ======================================
          // CONTENT
          // ======================================

          return SafeArea(
            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // ==================================
                  // FILTER
                  // ==================================

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

                  // ==================================
                  // SPACE BEFORE CARDS
                  // ==================================

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================
                  // FANDOM CARDS
                  // ==================================

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

                            members:
                            data['members']
                                ?.toString() ??
                                '0 members',
                          );
                        },
                      ),
                    ),

                  // ==================================
                  // BOTTOM SPACE
                  // ==================================

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