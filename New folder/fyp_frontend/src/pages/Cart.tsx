import React from 'react';
import { useCart } from '../context/CartContext';
import { Trash2, Minus, Plus, ShoppingBag, ArrowRight, ChevronLeft, Percent } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';

const Cart: React.FC = () => {
  const { cart, removeFromCart, updateQuantity, totalPrice, totalItems } = useCart();
  const navigate = useNavigate();

  if (cart.length === 0) {
    return (
      <div className="min-h-screen bg-[#FAFAFA] flex flex-col items-center justify-center px-4">
        <motion.div 
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="w-24 h-24 md:w-32 md:h-32 bg-white rounded-[2rem] md:rounded-[3rem] flex items-center justify-center mb-8 text-primary-500 shadow-xl shadow-slate-200/50"
        >
          <ShoppingBag size={48} />
        </motion.div>
        <h2 className="text-2xl md:text-3xl font-black text-slate-900 mb-2 uppercase tracking-tight">Your Bag is Empty</h2>
        <p className="text-slate-500 mb-10 max-w-xs text-center font-bold uppercase tracking-widest text-[9px] opacity-60 leading-relaxed">Time to add some delicious flavors to your life.</p>
        <Link to="/" className="bg-slate-900 hover:bg-primary-500 text-white font-black py-4 px-12 rounded-2xl transition-all uppercase tracking-widest text-[10px] shadow-xl active:scale-95">
          Start Exploring
        </Link>
      </div>
    );
  }

  return (
    <div className="bg-[#FAFAFA] min-h-screen pt-32 pb-32">
      <div className="container mx-auto px-4 max-w-6xl">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-12 md:mb-16 gap-8">
          <div>
            <Link to="/" className="text-[9px] font-black text-slate-400 hover:text-primary-600 flex items-center group mb-4 uppercase tracking-[0.2em] transition-colors">
              <ChevronLeft size={16} className="mr-2 group-hover:-translate-x-1 transition-transform" />
              Continue Shopping
            </Link>
            <h1 className="text-4xl md:text-5xl font-black text-slate-900 uppercase tracking-tighter">Your <span className="text-primary-500 italic">Bag</span></h1>
          </div>
          <div className="bg-white px-6 md:px-8 py-3 rounded-full border border-slate-100 shadow-sm flex items-center gap-4 w-fit">
             <ShoppingBag size={18} className="text-primary-500" />
             <span className="text-[9px] font-black text-slate-900 uppercase tracking-widest">{totalItems} Total Items</span>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 lg:gap-16">
          {/* Cart Items List */}
          <div className="lg:col-span-2 space-y-6">
            <AnimatePresence>
              {cart.map((item) => (
                <motion.div 
                  key={item.id}
                  layout
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, x: -100 }}
                  className="bg-white p-6 md:p-8 rounded-[2rem] md:rounded-[3rem] border border-slate-50 shadow-sm flex flex-col sm:flex-row items-center gap-6 md:gap-8 group hover:shadow-xl transition-all"
                >
                  <div className="w-20 h-20 md:w-24 md:h-24 bg-slate-50 rounded-2xl md:rounded-[2rem] overflow-hidden flex-shrink-0 border border-slate-100 p-1">
                    {item.imageUrl ? (
                      <img src={item.imageUrl} alt={item.title} className="w-full h-full object-cover rounded-xl md:rounded-[1.5rem]" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-slate-200">
                         <ShoppingBag size={32} />
                      </div>
                    )}
                  </div>
                  
                  <div className="flex-grow text-center sm:text-left">
                    <h4 className="font-black text-slate-900 uppercase text-base md:text-lg tracking-tight mb-2 group-hover:text-primary-600 transition-colors leading-tight">{item.title}</h4>
                    <div className="flex flex-wrap justify-center sm:justify-start gap-2 mb-4">
                       <span className="text-[7px] md:text-[8px] font-black bg-slate-100 px-3 py-1 rounded-full text-slate-500 uppercase tracking-widest">
                         Standard Serving
                       </span>
                    </div>
                    <div className="text-lg md:text-xl font-black text-slate-900">${item.price.toFixed(2)}</div>
                  </div>

                  <div className="flex items-center gap-4 md:gap-6 w-full sm:w-auto justify-center">
                    <div className="flex items-center bg-slate-50 border border-slate-100 rounded-2xl p-1 shadow-inner">
                      <button 
                        onClick={() => updateQuantity(item.id, Math.max(1, item.quantity - 1))}
                        className="w-8 h-8 md:w-10 md:h-10 bg-white shadow-sm rounded-xl flex items-center justify-center text-slate-400 hover:text-primary-500 transition-all font-bold"
                      >
                        <Minus size={14} />
                      </button>
                      <span className="w-10 text-center text-xs md:text-sm font-black text-slate-900">{item.quantity}</span>
                      <button 
                        onClick={() => updateQuantity(item.id, item.quantity + 1)}
                        className="w-8 h-8 md:w-10 md:h-10 bg-white shadow-sm rounded-xl flex items-center justify-center text-slate-400 hover:text-primary-500 transition-all font-bold"
                      >
                        <Plus size={14} />
                      </button>
                    </div>
                    
                    <button 
                      onClick={() => removeFromCart(item.id)}
                      className="w-10 h-10 md:w-12 md:h-12 flex items-center justify-center text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-xl md:rounded-2xl transition-all"
                    >
                      <Trash2 size={20} />
                    </button>
                  </div>
                </motion.div>
              ))}
            </AnimatePresence>
          </div>

          {/* Order Summary Sidebar */}
          <div className="space-y-8">
            <div className="bg-slate-900 text-white p-8 md:p-10 rounded-[2.5rem] md:rounded-[3rem] shadow-2xl relative overflow-hidden">
              <div className="absolute top-0 right-0 w-32 h-32 bg-primary-500/10 blur-3xl" />
              <h3 className="text-lg md:text-xl font-black uppercase tracking-tighter mb-8 md:mb-10 border-l-4 border-primary-500 pl-6">Summary</h3>
              
              <div className="space-y-6 text-[9px] md:text-[10px] font-black uppercase tracking-widest text-slate-400 mb-10">
                <div className="flex justify-between items-center">
                   <span>Subtotal</span>
                   <span className="text-white text-sm md:text-base">${totalPrice.toFixed(2)}</span>
                </div>
                <div className="flex justify-between items-center">
                   <span>Delivery Fee</span>
                   <span className="text-white text-sm md:text-base">$2.00</span>
                </div>
                <div className="flex justify-between items-center">
                   <span>Admin Tax</span>
                   <span className="text-white text-sm md:text-base">$1.50</span>
                </div>
                <div className="pt-8 border-t border-white/10 flex justify-between items-center">
                   <span className="text-primary-400">Total To Pay</span>
                   <span className="text-2xl md:text-3xl font-black text-white tracking-tighter">${(totalPrice + 3.5).toFixed(2)}</span>
                </div>
              </div>

              <button 
                onClick={() => navigate('/checkout')}
                className="w-full bg-primary-500 hover:bg-primary-600 text-white font-black py-5 rounded-2xl transition-all shadow-xl shadow-primary-500/20 flex items-center justify-center group uppercase tracking-widest text-[9px] md:text-[10px]"
              >
                Proceed to Checkout
                <ArrowRight className="ml-3 group-hover:translate-x-1 transition-transform" size={16} />
              </button>
            </div>

            <div className="bg-white p-8 md:p-10 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-xl shadow-slate-200/50">
               <div className="flex items-center text-primary-500 mb-6">
                  <div className="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center mr-4"><Percent size={18} /></div>
                  <h4 className="text-[9px] md:text-[10px] font-black uppercase tracking-widest">Apply Promo Code</h4>
               </div>
               <div className="relative group">
                  <input 
                    type="text" 
                    placeholder="ENTER CODE..." 
                    className="w-full bg-slate-50 border border-slate-100 rounded-2xl py-4 px-6 text-[9px] md:text-[10px] font-black text-slate-900 uppercase tracking-widest focus:ring-2 focus:ring-primary-500 transition-all outline-none" 
                  />
                  <button className="absolute right-2 top-1/2 -translate-y-1/2 bg-slate-900 text-white text-[8px] font-black px-4 py-2 rounded-xl uppercase tracking-widest hover:bg-primary-500 transition-colors">Apply</button>
               </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;
