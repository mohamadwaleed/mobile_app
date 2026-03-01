// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelDetails extends StatefulWidget {
  HotelDetails({super.key});

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails>
    with SingleTickerProviderStateMixin {
  final images = [
    'images/hotels/hotel1.webp',
    'images/hotels/hotel2.webp',
    'images/hotels/hotel3.webp',
    'images/hotels/hotel4.webp',
  ];

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));

  late TabController _tabController;

  // Dummy room data
  final List<Map<String, dynamic>> rooms = [
    {
      'name': 'Deluxe Room - 2 Single Beds',
      'image': 'images/hotels/hotel1.webp',
      'beds': '2 Single Beds, Fits 2',
      'size': '32 m²',
      'wifi': true,
      'photoCount': 3,
      'options': [
        {
          'title': 'Room only',
          'refundable': false,
          'breakfast': false,
          'price': 1370,
        },
        {
          'title': 'Bed and Breakfast',
          'refundable': false,
          'breakfast': true,
          'price': 1570,
        },
      ],
    },
    {
      'name': 'Superior Room - King Bed',
      'image': 'images/hotels/hotel2.webp',
      'beds': '1 King Bed, Fits 2',
      'size': '40 m²',
      'wifi': true,
      'photoCount': 4,
      'options': [
        {
          'title': 'Room only',
          'refundable': true,
          'breakfast': false,
          'price': 1850,
        },
        {
          'title': 'Bed and Breakfast',
          'refundable': false,
          'breakfast': true,
          'price': 2100,
        },
      ],
    },
  ];

  // Which room's options are expanded
  List<bool> _expanded = [true, false];

  // Selected date offset for the date selector row
  int _selectedDateOffset = 0;

  // Active filter chips
  Set<String> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  static const Color _teal = Color(0xFF1f93a0);
  static const Color _red = Color(0xFFE84545);

  String _offsetLabel(int offset) {
    final d = DateTime.now().add(Duration(days: offset));
    return '${DateFormat('dd MMM').format(d)}–${DateFormat('dd MMM').format(d.add(Duration(days: 1)))}';
  }

  // ─── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hotel', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: _teal,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.favorite_outline), onPressed: () {}),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: _buildHeader()),
        ],
        body: Column(
          children: [
            // ── Tab bar ──
            TabBar(
              controller: _tabController,
              labelColor: _teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _teal,
              indicatorWeight: 2.5,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              unselectedLabelStyle: TextStyle(fontSize: 15),
              tabs: [
                Tab(text: 'Select room'),
                Tab(text: 'Property details'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSelectRoomTab(),
                  _buildPropertyDetailsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── header (existing code, untouched layout) ─────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        // Image slider
        Container(
          height: 200,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) =>
                    Image.asset(images[index], fit: BoxFit.cover),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      Text('4 📷', style: TextStyle(color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Some Hotel Somewhere',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 51, 161, 212),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Hotel',
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 8),
                        for (int i = 1; i <= 3; i++)
                          Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        // Rating + reviews row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('7.0',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    SizedBox(height: 3),
                    Text('Good', style: TextStyle(color: Colors.black)),
                    Text('103 Reviews',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 227, 246, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('103 Reviews',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text('View Reviews',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Location row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Image.asset('images/Gmaps.jpg'),
              Expanded(
                child: Column(
                  children: [
                    Text('Location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                        'Somewhere in the world that starts with an N.\nProbably a third world country.'),
                    TextButton(
                      onPressed: () {},
                      child: Text('Open in Maps',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Check-in / Check-out / Guests row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => checkInDate = picked);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    foregroundColor: _teal,
                  ),
                  child: Column(
                    children: [
                      Text('Check in',
                          style: TextStyle(color: Colors.black)),
                      Text(DateFormat('dd MMM').format(checkInDate),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: checkOutDate,
                      firstDate: checkInDate.add(Duration(days: 1)),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => checkOutDate = picked);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    foregroundColor: _teal,
                  ),
                  child: Column(
                    children: [
                      Text('Check out',
                          style: TextStyle(color: Colors.black)),
                      Text(DateFormat('dd MMM').format(checkOutDate),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 25),
                    foregroundColor: _teal,
                  ),
                  child: Text('1 Room, 1 Adult, 0 Children',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8),
      ],
    );
  }

  // ─── Tab 1: Select Room ───────────────────────────────────────────────────

  Widget _buildSelectRoomTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // "Explore other dates" section
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: _teal, size: 18),
            SizedBox(width: 8),
            Text('Explore other dates for your trip',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
        SizedBox(height: 12),

        // Horizontal date selector
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(width: 10),
            itemBuilder: (context, i) {
              final isSelected = i == _selectedDateOffset;
              final label = _offsetLabel(i);
              return GestureDetector(
                onTap: () => setState(() => _selectedDateOffset = i),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 140,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFFE0F5F7)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected ? _teal : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: i == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Your dates',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            SizedBox(height: 2),
                            Text('₴ 1,370',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(label,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, color: _teal),
                            SizedBox(height: 4),
                            Text(label,
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 12)),
                          ],
                        ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 6),
        Text(
          'Actual prices for suggested dates may vary slightly.',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),

        SizedBox(height: 16),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['With view', 'Breakfast included', 'Bedding Preference']
                .map((f) {
              final active = _activeFilters.contains(f);
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(f),
                  selected: active,
                  onSelected: (v) => setState(() =>
                      v ? _activeFilters.add(f) : _activeFilters.remove(f)),
                  selectedColor: Color(0xFFE0F5F7),
                  checkmarkColor: _teal,
                  labelStyle: TextStyle(
                      color: active ? _teal : Colors.black87,
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal),
                  shape: StadiumBorder(
                      side: BorderSide(
                          color: active ? _teal : Colors.grey[400]!)),
                  backgroundColor: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 16),

        // Room cards
        ...List.generate(rooms.length, (i) => _buildRoomCard(i)),
      ],
    );
  }

  Widget _buildRoomCard(int index) {
    final room = rooms[index];
    final expanded = _expanded[index];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room header
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            room['image'],
                            width: 130,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text('${room['photoCount']} ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                Icon(Icons.photo_outlined,
                                    color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    // Room specs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _roomSpec(Icons.bed_outlined, room['beds']),
                          SizedBox(height: 6),
                          _roomSpec(Icons.open_in_full, room['size']),
                          if (room['wifi']) ...[
                            SizedBox(height: 6),
                            _roomSpec(Icons.wifi, 'Wi-Fi'),
                          ],
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Text('View room details',
                                style: TextStyle(
                                    color: _teal,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // Hide / Show options toggle
          InkWell(
            onTap: () => setState(() => _expanded[index] = !expanded),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    expanded ? 'Hide options' : 'Show options',
                    style: TextStyle(
                        color: _teal, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 6),
                  AnimatedRotation(
                    turns: expanded ? 0 : 0.5,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          color: _teal, shape: BoxShape.circle),
                      child: Icon(Icons.keyboard_arrow_up,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Booking options
          if (expanded)
            ...List.generate(
              room['options'].length,
              (j) => _buildBookingOption(
                  room['options'][j], j < room['options'].length - 1),
            ),
        ],
      ),
    );
  }

  Widget _roomSpec(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]))),
      ],
    );
  }

  Widget _buildBookingOption(Map<String, dynamic> option, bool showDivider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(option['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('View details',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                        Icon(Icons.chevron_right,
                            color: Colors.grey[600], size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.block, size: 15, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    option['refundable']
                        ? 'Refundable'
                        : 'Non-refundable',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              if (option['breakfast']) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.coffee_outlined,
                        size: 15, color: _teal),
                    SizedBox(width: 6),
                    Text('Including Breakfast',
                        style: TextStyle(
                            color: _teal,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.stars_outlined, size: 15, color: Colors.grey),
                  SizedBox(width: 6),
                  Text('Earn rewards (mokafaa / Qitaf / AlFursan)',
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('₴ ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('${option['price']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ],
                      ),
                      Text('for 1 night (incl. VAT)',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Select',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  // ─── Tab 2: Property Details ──────────────────────────────────────────────

  Widget _buildPropertyDetailsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _sectionTitle('About the property'),
        SizedBox(height: 8),
        Text(
          'Some Hotel Somewhere offers a unique stay experience combining modern comforts with local charm. '
          'Located in the heart of the city, guests enjoy easy access to major attractions, '
          'shopping centers, and fine dining. The property features beautifully designed rooms '
          'with floor-to-ceiling windows overlooking the skyline.',
          style: TextStyle(color: Colors.grey[700], height: 1.5),
        ),

        SizedBox(height: 24),
        _sectionTitle('Facilities'),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _facilityChip(Icons.pool, 'Swimming Pool'),
            _facilityChip(Icons.fitness_center, 'Gym'),
            _facilityChip(Icons.wifi, 'Free Wi-Fi'),
            _facilityChip(Icons.local_parking, 'Parking'),
            _facilityChip(Icons.restaurant, 'Restaurant'),
            _facilityChip(Icons.spa, 'Spa'),
            _facilityChip(Icons.room_service, 'Room Service'),
            _facilityChip(Icons.ac_unit, 'Air Conditioning'),
            _facilityChip(Icons.local_bar, 'Bar'),
            _facilityChip(Icons.business_center, 'Business Center'),
          ],
        ),

        SizedBox(height: 24),
        _sectionTitle('Check-in / Check-out Policy'),
        SizedBox(height: 10),
        _policyRow(Icons.login, 'Check-in', 'From 3:00 PM'),
        SizedBox(height: 8),
        _policyRow(Icons.logout, 'Check-out', 'Until 12:00 PM'),
        SizedBox(height: 8),
        _policyRow(Icons.child_care, 'Children', 'Children of all ages welcome'),
        SizedBox(height: 8),
        _policyRow(Icons.pets, 'Pets', 'No pets allowed'),

        SizedBox(height: 24),
        _sectionTitle('Important Information'),
        SizedBox(height: 8),
        _bulletPoint(
            'A valid credit card and government-issued photo ID are required at check-in.'),
        _bulletPoint('The property may pre-authorize your card upon arrival.'),
        _bulletPoint('Special requests are subject to availability.'),
        _bulletPoint('Smoking is not permitted on the premises.'),

        SizedBox(height: 32),
      ],
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      );

  Widget _facilityChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFE0F5F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _teal),
          SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: _teal, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _policyRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _teal),
        SizedBox(width: 10),
        Text('$label: ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        Text(value, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
      ],
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  color: _teal, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style:
                      TextStyle(color: Colors.grey[700], height: 1.4))),
        ],
      ),
    );
  }
}