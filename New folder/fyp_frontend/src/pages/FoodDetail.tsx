import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ChevronLeft, Star, Clock, ShoppingBag, Plus, Minus, Heart, Share2, ShieldCheck, Flame } from 'lucide-react';
import { motion } from 'framer-motion';
import { useCart } from '../context/CartContext';
import { getAllMockItems } from '../utils/mockData';

const FoodDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { addToCart } = useCart();
  const [item, setItem] = useState<any>(null);
  const [quantity, setQuantity] = useState(1);

  useEffect(() => {
    // Traverse all restaurants and their menus to find the item
    const allItems = getAllMockItems();
    const found = allItems.find(i => i.id === id);
    if (found) setItem(found);
  }, [id]);

  if (!item) return <div className="h-screen bg-black flex items-center justify-center font-black text-primary-500 uppercase tracking-[0.5em] animate-pulse">Scanning Flavors...</div>;

  const handleAdd = () => {
    addToCart({ ...item, quantity });
    navigate('/cart');
  };

  return (
    <div className="bg-[#FAFAFA] min-h-screen pt-32 pb-32">
      <div className="container mx-auto px-4 max-w-6xl">
        <button onClick={() => navigate(-1)} className="flex items-center gap-2 text-slate-400 hover:text-primary-500 transition-all mb-8 font-black uppercase text-[9px] tracking-widest">
           <ChevronLeft size={16} /> Previous Page
        </button>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20">
          
          {/* Image Gallery */}
          <motion.div 
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="space-y-6"
          >
             <div className="aspect-square rounded-[3.5rem] overflow-hidden bg-white border-8 border-white shadow-2xl relative">
                <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                <div className="absolute top-6 right-6 flex flex-col gap-4">
                   <button className="bg-white/90 backdrop-blur-md p-4 rounded-2xl shadow-xl text-slate-300 hover:text-red-500 transition-all"><Heart size={20}/></button>
                   <button className="bg-white/90 backdrop-blur-md p-4 rounded-2xl shadow-xl text-slate-300 hover:text-primary-500 transition-all"><Share2 size={20}/></button>
                </div>
                <div className="absolute bottom-6 left-6 bg-slate-900/80 backdrop-blur-md px-6 py-3 rounded-full flex items-center gap-3">
                   <Flame size={18} className="text-primary-500" />
                   <span className="text-[10px] font-black text-white uppercase tracking-widest">Premium Selection</span>
                </div>
             </div>
             <div className="grid grid-cols-4 gap-4">
                {[1,2,3,4].map((i) => (
                  <div key={i} className="aspect-square rounded-2xl bg-white border-4 border-white shadow-md overflow-hidden opacity-40 hover:opacity-100 transition-opacity cursor-pointer">
                     <img src={item.image} className="w-full h-full object-cover" />
                  </div>
                ))}
             </div>
          </motion.div>

          {/* Details Content */}
          <div className="flex flex-col h-full">
             <div className="flex-grow">
                <div className="flex items-center gap-4 mb-6">
                   <div className="flex items-center text-amber-500 bg-amber-50 px-4 py-2 rounded-full border border-amber-100">
                      <Star size={14} className="fill-current mr-2" />
                      <span className="text-[10px] font-black">{item.rating} (1.2k Reviews)</span>
                   </div>
                   <div className="flex items-center text-primary-600 bg-primary-50 px-4 py-2 rounded-full border border-primary-100">
                      <Clock size={14} className="mr-2" />
                      <span className="text-[10px] font-black uppercase tracking-widest">20-30 MINS</span>
                   </div>
                </div>

                <h1 className="text-4xl md:text-5xl lg:text-6xl font-black text-slate-900 uppercase tracking-tighter mb-6 leading-tight">{item.title}</h1>
                <p className="text-slate-500 text-sm md:text-base font-bold uppercase tracking-widest leading-relaxed mb-10 opacity-70">
                   {item.description} Handcrafted with fresh ingredients, including local seasonal produce and signature house sauces. Experience the perfect harmony of textures and authentic flavors in every bite.
                </p>

                <div className="bg-white rounded-[2.5rem] p-8 border border-slate-50 shadow-xl shadow-slate-200/50 mb-10">
                   <h4 className="text-[9px] font-black uppercase tracking-[0.3em] text-slate-400 mb-6">Customize Order</h4>
                   <div className="space-y-4">
                      {['Extra Organic Cheese', 'Spicy Sriracha Glaze', 'Gluten Free Bun'].map((addon) => (
                        <div key={addon} className="flex justify-between items-center group cursor-pointer hover:bg-slate-50 p-4 rounded-xl transition-all">
                           <span className="text-[10px] font-black text-slate-900 uppercase tracking-widest">{addon}</span>
                           <div className="w-6 h-6 border-2 border-slate-100 rounded-lg flex items-center justify-center group-hover:border-primary-500 transition-all">
                              <Plus size={14} className="text-slate-100 group-hover:text-primary-500" />
                           </div>
                        </div>
                      ))}
                   </div>
                </div>
             </div>

             <div className="mt-auto space-y-6">
                <div className="flex items-center justify-between">
                   <div className="flex items-center bg-white border border-slate-100 rounded-2xl p-1.5 shadow-xl">
                      <button onClick={() => setQuantity(Math.max(1, quantity - 1))} className="w-12 h-12 bg-slate-50 rounded-xl flex items-center justify-center text-slate-900 hover:bg-primary-50 transition-all"><Minus size={18}/></button>
                      <span className="w-16 text-center font-black text-xl text-slate-900">{quantity}</span>
                      <button onClick={() => setQuantity(quantity + 1)} className="w-12 h-12 bg-slate-50 rounded-xl flex items-center justify-center text-slate-900 hover:bg-primary-50 transition-all"><Plus size={18}/></button>
                   </div>
                   <div className="text-right">
                      <p className="text-[9px] font-black uppercase tracking-widest text-slate-400">Total Price</p>
                      <p className="text-4xl font-black text-slate-900 tracking-tighter">${(item.price * quantity).toFixed(2)}</p>
                   </div>
                </div>

                <button onClick={handleAdd} className="w-full bg-slate-900 hover:bg-primary-500 text-white py-6 rounded-3xl font-black uppercase text-[10px] tracking-[0.4em] shadow-2xl shadow-slate-900/20 transition-all flex items-center justify-center gap-4 group active:scale-95">
                   <ShoppingBag size={20} className="group-hover:translate-y-[-2px] transition-transform" /> Add To Shopping Bag
                </button>
                
                <div className="flex items-center justify-center gap-3 text-slate-400 py-4">
                   <ShieldCheck size={16} className="text-emerald-500" />
                   <p className="text-[8px] font-black uppercase tracking-[0.2em]">Quality Guarantee • Secure Packaging</p>
                </div>
             </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default FoodDetail;
