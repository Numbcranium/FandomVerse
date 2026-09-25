import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================
  // GET FANDOMS FROM FIRESTORE
  // ==========================================

  Stream<QuerySnapshot<Map<String, dynamic>>> _searchFandoms() {
    return _firestore
        .collection('fandoms')
        .snapshots();
  }

  // ==========================================
  // SAVE SEARCH HISTORY
  // ==========================================

  Future<void> saveSearchText(String search) async {
    if (search.trim().isEmpty) return;

    try {
      await _firestore.collection('search_history').add({
        'searchText': search.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  // ==========================================
  // PERFORM SEARCH
  // ==========================================

  Future<void> performSearch(String value) async {
    final search = value.trim();

    if (search.isEmpty) {
      setState(() {
        searchText = '';
      });
      return;
    }

    // Save ONE search when user submits it
    await saveSearchText(search);

    if (!mounted) return;

    setState(() {
      searchText = search.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0A25),

      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0A25),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ======================================
            // SEARCH FIELD
            // ======================================

            TextField(
              controller: _searchController,

              style: const TextStyle(
                color: Colors.white,
              ),

              // Show search button on keyboard
              textInputAction: TextInputAction.search,

              // Search when user presses keyboard search
              onSubmitted: (value) async {
                await performSearch(value);
              },

              // Only update the text.
              // DO NOT save to Firebase here.
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase().trim();
                });
              },

              decoration: InputDecoration(
                hintText:
                'Search fandoms, anime, events, movies...',

                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),

                // Clear button
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      searchText = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white54,
                  ),
                )
                    : null,

                filled: true,

                fillColor: const Color(0xFF17163D),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // NOTHING SEARCHED YET
            // ======================================

            if (searchText.isEmpty)

              const Expanded(
                child: Center(
                  child: Text(
                    'Search for a fandom',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ),
              )

            // ======================================
            // SEARCH RESULTS
            // ======================================

            else

              Expanded(
                child: StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  stream: _searchFandoms(),

                  builder: (context, snapshot) {


                    // LOADING


                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // --------------------------------
                    // ERROR
                    // --------------------------------

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }


                    // FIRESTORE DOCUMENTS


                    final docs =
                        snapshot.data?.docs ?? [];


                    // FILTER RESULTS


                    final results = docs.where((doc) {
                      final data = doc.data();

                      final name =
                          data['name']
                              ?.toString()
                              .toLowerCase() ??
                              '';

                      final category =
                          data['category']
                              ?.toString()
                              .toLowerCase() ??
                              '';

                      return name.contains(searchText) ||
                          category.contains(searchText);
                    }).toList();

                    // --------------------------------
                    // NO RESULTS
                    // --------------------------------

                    if (results.isEmpty) {
                      return const Center(
                        child: Text(
                          'No fandoms found',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    // --------------------------------
                    // RESULTS
                    // --------------------------------

                    return ListView.builder(
                      itemCount: results.length,

                      itemBuilder: (context, index) {
                        final doc = results[index];

                        final data = doc.data();

                        final String name =
                            data['name']?.toString() ?? '';

                        final String image =
                            data['image']?.toString() ?? '';

                        final String category =
                            data['category']?.toString() ?? '';

                        // --------------------------------
                        // RESULT CARD
                        // --------------------------------

                        return GestureDetector(
                          onTap: () {
                            // We DO NOT save history here.
                            // It was already saved when
                            // the search was submitted.

                            context.push(
                              '/fandom/${doc.id}',
                            );
                          },

                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),

                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: const Color(0xFF17163D),

                              borderRadius:
                              BorderRadius.circular(14),
                            ),

                            child: Row(
                              children: [



                                // IMAGE


                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10),

                                  child: Image.asset(
                                    image,

                                    width: 70,
                                    height: 70,

                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {
                                      return Container(
                                        width: 70,
                                        height: 70,

                                        color:
                                        Colors.grey.shade800,

                                        child: const Icon(
                                          Icons
                                              .image_not_supported,
                                          color:
                                          Colors.white54,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 14),


                                // NAME + CATEGORY


                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        name,

                                        style:
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        category,

                                        style:
                                        const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}