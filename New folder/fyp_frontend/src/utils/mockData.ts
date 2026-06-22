export const MOCK_RESTAURANTS = [
  {
    id: "rest-1",
    title: "The Gourmet Kitchen",
    rating: 4.9,
    reviews: 1205,
    time: "20-30 min",
    category: "International",
    logoUrl: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&q=80&w=200",
    bannerUrl: "https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&q=80&w=2070",
    description: "Experience the pinnacle of culinary excellence with our curated international menu.",
    coords: { address: "123 Gourmet St, San Francisco" },
    menu: [
      {
        category: "Famous Burgers",
        items: [
          { id: "f1", title: "Truffle Burger", description: "Juicy beef patty with black truffle oil and aged cheddar.", price: 18.0, image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=300", rating: 4.9 },
          { id: "f2", title: "Classic Cheeseburger", description: "The timeless classic with our secret sauce.", price: 14.0, image: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&q=80&w=300", rating: 4.7 }
        ]
      },
      {
        category: "Premium Sides",
        items: [
          { id: "f3", title: "Truffle Fries", description: "Hand-cut potatoes tossed in truffle salt.", price: 7.0, image: "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&q=80&w=300", rating: 4.8 },
          { id: "f4", title: "Onion Rings", description: "Crispy beer-battered onion rings.", price: 6.0, image: "https://images.unsplash.com/photo-1639024471283-03518883512d?auto=format&fit=crop&q=80&w=300", rating: 4.5 }
        ]
      }
    ]
  },
  {
    id: "rest-2",
    title: "Pizza Emporium",
    rating: 4.7,
    reviews: 850,
    time: "15-25 min",
    category: "Italian",
    logoUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=200",
    bannerUrl: "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&q=80&w=2070",
    description: "Authentic wood-fired pizzas made with imported Italian ingredients.",
    coords: { address: "456 West Side Blvd, San Francisco" },
    menu: [
      {
        category: "Signature Pizzas",
        items: [
          { id: "f5", title: "Margherita", description: "San Marzano tomatoes, fresh mozzarella, and basil.", price: 16.0, image: "https://images.unsplash.com/photo-1574071318508-1cdbad80ad38?auto=format&fit=crop&q=80&w=300", rating: 4.9 },
          { id: "f6", title: "Pepperoni Passion", description: "Loaded with premium pepperoni and extra cheese.", price: 18.0, image: "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&q=80&w=300", rating: 4.8 }
        ]
      }
    ]
  }
];

export const MOCK_CATEGORIES = [
  { id: "1", title: "Burgers", imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png" },
  { id: "2", title: "Pizza", imageUrl: "https://cdn-icons-png.flaticon.com/512/3595/3595455.png" },
  { id: "3", title: "Sushi", imageUrl: "https://cdn-icons-png.flaticon.com/512/2252/2252438.png" },
  { id: "4", title: "Desserts", imageUrl: "https://cdn-icons-png.flaticon.com/512/2234/2234855.png" },
  { id: "5", title: "Healthy", imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046777.png" },
  { id: "6", title: "Drinks", imageUrl: "https://cdn-icons-png.flaticon.com/512/2405/2405479.png" }
];

export const getAllMockItems = () => {
  return MOCK_RESTAURANTS.flatMap(r => r.menu.flatMap(m => m.items));
};
