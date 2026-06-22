import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Star, Clock, MapPin, ChevronLeft, ShoppingBag, ChevronRight } from 'lucide-react';
import { useCart } from '../context/CartContext';
import { motion, AnimatePresence } from 'framer-motion';
import { getRestaurantDetails } from '../services/api';
import CustomizationModal from '../components/food/CustomizationModal';
import FoodCard from '../components/food/FoodCard';

const RestaurantDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { addToCart } = useCart();
  const [restaurant, setRestaurant] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [activeCategory, setActiveCategory] = useState<string>('');
  const [selectedItem, setSelectedItem] = useState<any>(null);

  useEffect(() => {
    const fetchDetails = async () => {
      if (id) {
        const res = await getRestaurantDetails(id);
        const data = res.data;
        setRestaurant(data);
        if (data?.menu?.length > 0) {
          setActiveCategory(data.menu[0].category);
        }
        setLoading(false);
      }
    };
    fetchDetails();
  }, [id]);

  const currentCategoryData = restaurant?.menu?.find((m: any) => m.category === activeCategory);

  if (loading) return <div className="h-screen bg-black flex items-center justify-center font-black text-primary-500 uppercase tracking-[0.5em] animate-pulse">Loading Kitchen...</div>;

  return (
    <div className="bg-[#FAFAFA] min-h-screen pb-32">
      {/* 1. Hero Banner */}
      <section className="relative h-[250px] md:h-[350px] overflow-hidden">
        <img 
          src={restaurant?.logoUrl} 
          alt={restaurant?.title} 
          className="absolute inset-0 w-full h-full object-cover blur-[2px] scale-110 opacity-40"
        />
        <div className="absolute inset-0 bg-slate-900/80 backdrop-blur-sm" />
        
        <div className="container mx-auto px-4 h-full flex flex-col justify-end pb-8 md:pb-12 relative z-10">
          <button 
            onClick={() => navigate('/')}
            className="absolute top-6 left-4 md:left-8 bg-white/5 backdrop-blur-xl p-2.5 rounded-xl text-white hover:bg-white/10 transition-all border border-white/10"
          >
            <ChevronLeft size={18} />
          </button>

          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
            <div className="max-w-3xl">
              <div className="flex items-center gap-2 mb-3">
                 <span className="bg-primary-500 text-white text-[7px] md:text-[8px] font-black px-2.5 py-1 rounded-full uppercase tracking-widest">Open Now</span>
                 <div className="flex items-center text-amber-400">
                    <Star size={12} className="fill-current mr-1" />
                    <span className="text-[10px] font-black">{restaurant?.rating}</span>
                 </div>
              </div>
              <h1 className="text-3xl md:text-5xl font-black text-white uppercase tracking-tighter mb-3 leading-tight">{restaurant?.title}</h1>
              <div className="flex flex-wrap items-center gap-4 text-slate-400">
                 <span className="flex items-center gap-1.5 text-[9px] uppercase font-bold tracking-widest"><MapPin size={12} className="text-primary-500" /> {restaurant?.coords?.address?.split(',')[0]}</span>
                 <span className="flex items-center gap-1.5 text-[9px] uppercase font-bold tracking-widest"><Clock size={12} className="text-primary-500" /> {restaurant?.time || '25 MINS'}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <div className="container mx-auto px-4 mt-8">
        <div className="flex flex-col lg:flex-row gap-10">
          
          {/* 2. Menu Categories */}
          <aside className="lg:w-56 flex-shrink-0">
             <div className="sticky top-28">
                <h3 className="text-[9px] font-black uppercase tracking-[0.3em] text-slate-400 mb-5 px-3 hidden lg:block">Menu Categories</h3>
                <div className="flex lg:flex-col gap-2 overflow-x-auto lg:overflow-visible no-scrollbar pb-2 lg:pb-0">
                   {restaurant?.menu?.map((m: any) => (
                     <button
                        key={m.category}
                        onClick={() => setActiveCategory(m.category)}
                        className={`whitespace-nowrap px-5 py-3.5 rounded-xl md:rounded-[1.2rem] font-black uppercase text-[8px] md:text-[9px] tracking-widest transition-all text-left flex items-center justify-between group ${
                          activeCategory === m.category ? 'bg-slate-900 text-white shadow-lg' : 'bg-white text-slate-500 hover:bg-slate-50'
                        }`}
                     >
                        {m.category}
                        <ChevronRight size={12} className={`hidden lg:block transition-transform ${activeCategory === m.category ? 'translate-x-1 opacity-100' : 'opacity-0'}`} />
                     </button>
                   ))}
                </div>
             </div>
          </aside>

          {/* 3. Items Grid */}
          <main className="flex-grow">
             <div className="flex items-center justify-between mb-8">
                <h2 className="text-2xl font-black uppercase tracking-tighter text-slate-900">{activeCategory}</h2>
             </div>

             <div className="grid grid-cols-2 sm:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 gap-4 md:gap-6">
                {currentCategoryData?.items?.map((item: any) => (
                  <FoodCard 
                    key={item.id} 
                    item={item} 
                    onAdd={(it) => setSelectedItem(it)}
                  />
                ))}
             </div>
          </main>

        </div>
      </div>

      <AnimatePresence>
         <motion.div 
            initial={{ y: 50, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="fixed bottom-6 left-4 right-4 z-50 lg:hidden"
         >
            <button 
               onClick={() => navigate('/cart')}
               className="w-full bg-primary-500 text-white py-4 rounded-xl font-black uppercase text-[9px] tracking-[0.3em] shadow-2xl flex items-center justify-center gap-3 active:scale-95 transition-all"
            >
               <ShoppingBag size={16} /> View Bag
            </button>
         </motion.div>
      </AnimatePresence>

      <CustomizationModal 
        item={selectedItem} 
        isOpen={!!selectedItem} 
        onClose={() => setSelectedItem(null)} 
        onConfirm={(it) => {
          addToCart(it);
          setSelectedItem(null);
        }} 
      />
    </div>
  );
};

export default RestaurantDetail;