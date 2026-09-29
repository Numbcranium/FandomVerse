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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        title: Text(
          'Search',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
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

              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
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

                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),

                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                )
                    : null,

                filled: true,

                fillColor: Theme.of(context).cardColor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // ======================================
            // NOTHING SEARCHED YET
            // ======================================

            if (searchText.isEmpty)

              Expanded(
                child: Center(
                  child: Text(
                    'Search for a fandom',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
                      return Center(
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
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      return Center(
                        child: Text(
                          'No fandoms found',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
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
                              color: Theme.of(context).cardColor,

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

                                        child: Icon(
                                          Icons
                                              .image_not_supported,
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(width: 14),


                                // NAME + CATEGORY


                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        name,

                                        style:
                                        TextStyle(
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 5),

                                      Text(
                                        category,

                                        style:
                                        TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
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