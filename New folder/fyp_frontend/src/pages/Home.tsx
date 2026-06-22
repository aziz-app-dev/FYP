import React, { useEffect, useState } from 'react';
import { ChevronRight, Star, Search, Percent, MapPin, Utensils, Zap } from 'lucide-react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { MOCK_CATEGORIES, MOCK_RESTAURANTS } from '../utils/mockData';
import FoodCard from '../components/food/FoodCard'; // Using the shared component for consistency

const Home: React.FC = () => {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        setData({
          banner: { imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=2070' },
          categories: MOCK_CATEGORIES,
          trending: [
            { id: "f1", title: "Volcano Sushi", restaurant: "Tokyo Garden", price: 24.00, rating: 4.9, image: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&q=80&w=400", description: "Fresh premium tuna with spicy aioli and gold leaf" },
            { id: "f2", title: "Black Truffle Pasta", restaurant: "Pasta Bella", price: 32.00, rating: 4.8, image: "https://images.unsplash.com/photo-1473093226795-af9932fe5856?auto=format&fit=crop&q=80&w=400", description: "Handmade pasta tossed in black truffle butter sauce" },
            { id: "f3", title: "Wagyu Gold Burger", restaurant: "Steakhouse Prime", price: 45.00, rating: 5.0, image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=400", description: "A5 Wagyu beef with 24k gold leaf and brioche bun" },
            { id: "f4", title: "Lobster Roll", restaurant: "Sea Harvest", price: 28.00, rating: 4.7, image: "https://images.unsplash.com/photo-1533682805518-48d1f5b8cd3a?auto=format&fit=crop&q=80&w=400", description: "Fresh Maine lobster on toasted buttery roll" },
          ],
          randomCuisines: [
            { title: "Mediterranean", icon: <Utensils size={24} />, color: "bg-emerald-500" },
            { title: "Nordic", icon: <Zap size={24} />, color: "bg-blue-500" },
            { title: "Street Food", icon: <MapPin size={24} />, color: "bg-amber-500" },
          ],
          deals: [
            { id: "d1", title: "BOGO Burger", restaurant: { title: "The Gourmet Kitchen" }, dealPrice: 10.99, originalPrice: 21.98, discountPercentage: 50 },
            { id: "d2", title: "Family Pizza Feast", restaurant: { title: "Pizza Emporium" }, dealPrice: 25.00, originalPrice: 45.00, discountPercentage: 45 }
          ],
          topFoods: [
            { id: "f1", title: "Truffle Burger", price: 18.00, rating: 4.9 },
            { id: "f2", title: "Pepperoni Passion", price: 15.00, rating: 4.8 }
          ],
          topRestaurants: MOCK_RESTAURANTS,
        });
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  if (loading) return <div className="h-screen bg-black flex items-center justify-center font-black text-primary-500 uppercase tracking-[0.5em] animate-pulse">Initializing FoodHub...</div>;

  const SectionHeader = ({ title, subtitle, onAction }: { title: string, subtitle?: string, onAction?: () => void }) => (
    <div className="flex flex-col md:flex-row md:items-end justify-between mb-8 md:mb-10 gap-4">
      <div>
        <span className="text-primary-500 font-bold text-[9px] md:text-[10px] uppercase tracking-[0.3em] mb-2 block">{subtitle || 'Discover'}</span>
        <h2 className="text-2xl md:text-3xl font-black uppercase tracking-tighter text-slate-900">{title}</h2>
      </div>
      {onAction && (
        <button onClick={onAction} className="group flex items-center text-[9px] md:text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-primary-600 transition-all w-fit">
          View All <ChevronRight size={16} className="ml-1 group-hover:translate-x-1 transition-transform" />
        </button>
      )}
    </div>
  );

  return (
    <div className="bg-[#FAFAFA] min-h-screen pb-32">
      <section className="relative h-[450px] md:h-[600px] overflow-hidden">
        <img 
          src={data?.banner?.imageUrl} 
          alt="Banner" 
          className="absolute inset-0 w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent" />
        <div className="container mx-auto px-4 h-full flex flex-col justify-end pb-16 md:pb-24 relative z-10">
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            className="max-w-2xl"
          >
            <span className="bg-primary-500 text-white text-[9px] md:text-[10px] font-black px-4 py-2 rounded-full uppercase tracking-[0.2em] mb-6 inline-block shadow-2xl shadow-primary-500/50">
              Premium Dining Experience
            </span>
            <h1 className="text-4xl sm:text-5xl md:text-6xl font-black text-white leading-[1.1] uppercase tracking-tighter mb-8 shadow-black/20 text-shadow-xl">
              Order The Best <br />
              <span className="text-primary-500 italic">Flavor</span> in Town.
            </h1>
            
            <div className="flex bg-white/10 backdrop-blur-3xl p-2 md:p-3 rounded-[2rem] shadow-2xl border border-white/20 max-w-lg group transition-all focus-within:ring-4 focus-within:ring-primary-500/30">
              <Search className="text-white/60 m-3 group-focus-within:text-primary-500 transition-colors hidden sm:block" size={20} />
              <input 
                type="text" 
                placeholder="Search food, restaurants..." 
                className="bg-transparent border-none text-white focus:ring-0 flex-grow font-bold uppercase text-[10px] tracking-widest placeholder:text-white/40 px-4 sm:px-0" 
              />
              <button className="bg-primary-500 hover:bg-primary-600 text-white font-black px-6 md:px-10 py-3 md:py-0 rounded-full transition-all uppercase tracking-widest text-[9px] md:text-[10px] shadow-lg">
                Find Food
              </button>
            </div>
          </motion.div>
        </div>
      </section>

      <div className="container mx-auto px-4 -mt-12 md:-mt-16 relative z-20 space-y-20 md:space-y-24">
        {/* 2. Categories Grid - Increased DENSITY */}
        <section>
          <div className="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-4 md:gap-6">
            {data?.categories?.map((cat: any, idx: number) => (
              <motion.div 
                key={idx}
                whileHover={{ y: -6 }}
                className="bg-white p-4 md:p-6 rounded-[2rem] md:rounded-[2.5rem] shadow-lg shadow-slate-200/40 border border-slate-50 flex flex-col items-center group cursor-pointer overflow-hidden transition-all duration-500 hover:bg-slate-900"
              >
                <div className="w-12 h-12 md:w-16 md:h-16 bg-primary-50 rounded-full mb-3 md:mb-4 flex items-center justify-center group-hover:bg-primary-500 transition-all duration-500">
                   <img src={cat.imageUrl} alt={cat.title} className="w-6 h-6 md:w-8 md:h-8 object-contain" />
                </div>
                <span className="font-black text-slate-900 text-[7px] md:text-[9px] uppercase tracking-[0.1em] group-hover:text-white transition-colors text-center">{cat.title}</span>
              </motion.div>
            ))}
          </div>
        </section>

        {/* 3. Trending Food - COMPACT CARDS */}
        <section>
           <SectionHeader title="Trending Now" subtitle="People's Choice" onAction={() => {}} />
           <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
              {data?.trending?.map((item: any) => (
                <FoodCard 
                   key={item.id} 
                   item={item} 
                   onAdd={() => navigate(`/restaurant/RES-001`)} // Quick navigate for demo
                />
              ))}
           </div>
        </section>

        {/* 4. Hot Deals - COMPACT */}
        <section>
          <SectionHeader title="Special Deals" subtitle="Limited Timing" />
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {data?.deals?.map((deal: any) => (
              <div key={deal.id} className="bg-white rounded-[2.5rem] p-6 relative overflow-hidden border border-slate-100 shadow-sm group hover:border-primary-100 transition-all">
                  <div className="flex flex-col h-full justify-between items-start gap-6">
                    <div>
                      <span className="flex items-center text-primary-500 font-black text-[8px] uppercase tracking-widest mb-3">
                        <Percent size={12} className="mr-1" /> {deal.discountPercentage}% OFF
                      </span>
                      <h3 className="text-slate-900 text-lg font-black uppercase tracking-tight mb-1">{deal.title}</h3>
                      <p className="text-slate-400 font-bold uppercase text-[8px] tracking-widest mb-4">{deal.restaurant.title}</p>
                      <div className="flex items-end gap-3">
                        <span className="text-slate-800 text-xl font-black">${deal.dealPrice}</span>
                        <span className="text-slate-300 line-through text-[10px] font-bold mb-1">${deal.originalPrice}</span>
                      </div>
                    </div>
                    <button className="w-full bg-slate-900 text-white font-black py-4 rounded-xl text-[8px] uppercase tracking-[0.3em] hover:bg-primary-500 transition-all shadow-lg active:scale-95">Claim Deal</button>
                  </div>
              </div>
            ))}
          </div>
        </section>

        {/* 5. Featured Restaurants - COMPACT */}
        <section>
          <SectionHeader title="Featured Restaurants" subtitle="Premium Experience" onAction={() => {}} />
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
            {data?.topRestaurants?.map((res: any) => (
              <motion.div 
                key={res.id}
                whileHover={{ x: 6 }}
                onClick={() => navigate(`/restaurant/${res.id}`)}
                className="bg-white p-4 md:p-6 rounded-[2rem] shadow-sm border border-slate-100 flex items-center gap-4 md:gap-6 cursor-pointer group hover:shadow-xl transition-all"
              >
                <div className="w-16 h-16 md:w-20 md:h-20 bg-slate-100 rounded-2xl flex-shrink-0 overflow-hidden border-2 border-slate-50">
                   <img src={res.logoUrl} alt={res.title} className="w-full h-full object-cover grayscale group-hover:grayscale-0 transition-all duration-700" />
                </div>
                <div className="flex-grow">
                  <h4 className="text-base md:text-lg font-black uppercase text-slate-900 group-hover:text-primary-600 transition-colors tracking-tighter">{res.title}</h4>
                  <div className="flex items-center gap-4 mt-2">
                    <span className="flex items-center text-[7px] font-black text-slate-400 uppercase tracking-widest"><MapPin size={10} className="mr-1 text-primary-500" /> {res.coords.address.split(',')[0]}</span>
                    <span className="flex items-center text-[7px] font-black text-slate-400 uppercase tracking-widest"><Star size={10} className="mr-1 text-amber-500 fill-amber-500" /> {res.rating}</span>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
};

export default Home;
