import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, MapPin, CreditCard, ShoppingBag, CheckCircle, ShieldCheck, Truck, ChevronRight } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { useCart } from '../context/CartContext';

const Checkout: React.FC = () => {
  const { cart, totalPrice, clearCart } = useCart();
  const navigate = useNavigate();
  const [step, setStep] = useState(1);
  const [isProcessing, setIsProcessing] = useState(false);

  const deliveryFee = 2.99;
  const tax = totalPrice * 0.08;
  const finalTotal = totalPrice + deliveryFee + tax;

  const handlePlaceOrder = () => {
    setIsProcessing(true);
    setTimeout(() => {
      setIsProcessing(false);
      clearCart();
      navigate('/order-tracking/ORD-8829');
    }, 2500);
  };

  if (cart.length === 0 && step !== 3) {
    return (
      <div className="h-screen flex flex-col items-center justify-center text-center p-4">
        <div className="w-20 h-20 md:w-24 md:h-24 bg-slate-100 rounded-full flex items-center justify-center text-slate-300 mb-6">
          <ShoppingBag size={48} />
        </div>
        <h2 className="text-xl md:text-2xl font-black uppercase tracking-tighter text-slate-900 mb-2">Your Cart is Empty</h2>
        <p className="text-slate-500 text-[10px] font-medium mb-8 uppercase tracking-widest">Add some delicious food before checking out!</p>
        <button onClick={() => navigate('/')} className="bg-primary-500 text-white px-8 py-4 rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-xl shadow-primary-500/30">Go Home</button>
      </div>
    );
  }

  return (
    <div className="bg-slate-50 min-h-screen pt-32 pb-32">
      <div className="container mx-auto px-4 max-w-5xl">
        <button onClick={() => navigate(-1)} className="flex items-center gap-2 text-slate-400 hover:text-primary-500 transition-all mb-8 font-black uppercase text-[9px] tracking-widest">
          <ChevronLeft size={16} /> Back to Bag
        </button>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-10 md:gap-12">
          
          {/* Main Checkout Flow */}
          <div className="lg:col-span-2 space-y-10 md:space-y-12">
            
            {/* Steps Progress - Mobile Optimized */}
            <div className="flex items-center justify-between px-6 md:px-8 py-6 md:py-8 bg-white rounded-[2rem] md:rounded-[2.5rem] shadow-sm border border-slate-100">
               {[1, 2, 3].map((s) => (
                 <React.Fragment key={s}>
                   <div className="flex flex-col items-center gap-2 relative">
                      <div className={`w-10 h-10 md:w-12 md:h-12 rounded-full flex items-center justify-center font-black text-xs transition-all ${
                        step >= s ? 'bg-primary-500 text-white shadow-lg shadow-primary-500/30' : 'bg-slate-100 text-slate-400'
                      }`}>
                        {step > s ? <CheckCircle size={18} /> : s}
                      </div>
                      <span className={`text-[7px] md:text-[8px] font-black uppercase tracking-[0.2em] ${step >= s ? 'text-slate-900' : 'text-slate-400'}`}>
                         {s === 1 ? 'Address' : s === 2 ? 'Payment' : 'Review'}
                      </span>
                   </div>
                   {s < 3 && <div className={`flex-grow h-1 mx-2 md:mx-4 rounded-full ${step > s ? 'bg-primary-500' : 'bg-slate-100'}`} />}
                 </React.Fragment>
               ))}
            </div>

            {/* Step Content */}
            <AnimatePresence mode="wait">
              {step === 1 && (
                <motion.div 
                  key="step1"
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  className="space-y-6 md:space-y-8"
                >
                  <div className="bg-white p-6 md:p-10 rounded-[2.5rem] md:rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-50">
                    <div className="flex items-center gap-4 mb-8">
                       <MapPin className="text-primary-500" size={24} />
                       <h3 className="text-xl md:text-2xl font-black uppercase tracking-tighter text-slate-900">Delivery Address</h3>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                       <div className="space-y-3">
                          <label className="text-[9px] font-black uppercase tracking-widest text-slate-400 px-4">Address Line 1</label>
                          <input type="text" placeholder="123 Luxury Ave" className="w-full bg-slate-50 border-none px-6 py-4 rounded-2xl focus:ring-4 focus:ring-primary-500/20 font-bold text-xs" />
                       </div>
                       <div className="space-y-3">
                          <label className="text-[9px] font-black uppercase tracking-widest text-slate-400 px-4">Apartment/Suite</label>
                          <input type="text" placeholder="Unit 402" className="w-full bg-slate-50 border-none px-6 py-4 rounded-2xl focus:ring-4 focus:ring-primary-500/20 font-bold text-xs" />
                       </div>
                    </div>
                    <div className="mt-8 p-6 bg-primary-50/50 rounded-2xl border border-primary-100 flex items-center gap-4">
                       <Truck size={20} className="text-primary-600" />
                       <div>
                          <p className="text-[9px] font-black uppercase tracking-widest text-primary-900">Priority Delivery</p>
                          <p className="text-[10px] font-bold text-primary-700">Estimated Arrival: 25-35 Minutes</p>
                       </div>
                    </div>
                  </div>
                  <button onClick={() => setStep(2)} className="w-full bg-slate-900 text-white py-5 rounded-2xl md:rounded-[2rem] font-black uppercase text-[10px] tracking-[0.3em] hover:bg-primary-500 transition-all shadow-2xl flex items-center justify-center gap-3 group">
                    Continue to Payment <ChevronRight size={16} className="group-hover:translate-x-1 transition-transform" />
                  </button>
                </motion.div>
              )}

              {step === 2 && (
                <motion.div 
                  key="step2"
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  className="space-y-6 md:space-y-8"
                >
                   <div className="bg-white p-6 md:p-10 rounded-[2.5rem] md:rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-50">
                    <div className="flex items-center gap-4 mb-8">
                       <CreditCard className="text-primary-500" size={24} />
                       <h3 className="text-xl md:text-2xl font-black uppercase tracking-tighter text-slate-900">Payment Method</h3>
                    </div>
                    <div className="space-y-4">
                       <div className="p-6 border-2 border-primary-500 bg-primary-50 rounded-[1.5rem] md:rounded-[2rem] flex items-center justify-between">
                          <div className="flex items-center gap-4">
                             <div className="w-10 h-10 md:w-12 md:h-12 bg-white rounded-xl flex items-center justify-center shadow-inner">
                                <CreditCard className="text-primary-500" size={18} />
                             </div>
                             <div>
                                <p className="text-[10px] font-black text-slate-900 uppercase tracking-widest">Visa 4429</p>
                                <p className="text-[8px] font-bold text-slate-500 uppercase">Expires 12/26</p>
                             </div>
                          </div>
                          <div className="w-5 h-5 rounded-full bg-primary-500 border-4 border-white shadow-md" />
                       </div>
                       <button className="w-full border-2 border-dashed border-slate-200 p-6 rounded-[1.5rem] md:rounded-[2rem] text-[9px] font-black uppercase tracking-[0.2em] text-slate-400 hover:border-primary-500 hover:text-primary-600 transition-all">
                          + Add New Method
                       </button>
                    </div>
                  </div>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                     <button onClick={() => setStep(1)} className="order-2 sm:order-1 border-2 border-slate-100 text-slate-900 py-5 rounded-2xl md:rounded-[2rem] font-black uppercase text-[10px] tracking-[0.3em] hover:bg-slate-50 transition-all">Back</button>
                     <button onClick={() => setStep(3)} className="order-1 sm:order-2 bg-slate-900 text-white py-5 rounded-2xl md:rounded-[2rem] font-black uppercase text-[10px] tracking-[0.3em] hover:bg-primary-500 transition-all shadow-2xl shadow-slate-900/20 flex items-center justify-center gap-3">Review Order <ChevronRight size={16} /></button>
                  </div>
                </motion.div>
              )}

              {step === 3 && (
                <motion.div 
                  key="step3"
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -20 }}
                  className="space-y-6 md:space-y-8"
                >
                   <div className="bg-white p-6 md:p-10 rounded-[2.5rem] md:rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-50">
                    <div className="flex items-center gap-4 mb-8">
                       <ShieldCheck className="text-primary-500" size={24} />
                       <h3 className="text-xl md:text-2xl font-black uppercase tracking-tighter text-slate-900">Final Review</h3>
                    </div>
                    <div className="space-y-5 pb-8 border-b border-slate-100">
                       {cart.map((item) => (
                         <div key={item.id} className="flex justify-between items-center">
                            <div className="flex items-center gap-4">
                               <span className="text-[9px] font-black text-primary-600 bg-primary-50 w-8 h-8 flex items-center justify-center rounded-lg">{item.quantity}x</span>
                               <span className="text-xs font-black text-slate-900 uppercase tracking-tight truncate max-w-[150px] sm:max-w-none">{item.title}</span>
                            </div>
                            <span className="text-xs font-black text-slate-900">${(item.price * item.quantity).toFixed(2)}</span>
                         </div>
                       ))}
                    </div>
                  </div>
                  <button 
                    disabled={isProcessing}
                    onClick={handlePlaceOrder} 
                    className={`w-full py-6 rounded-[2rem] font-black uppercase text-xs tracking-[0.4em] transition-all shadow-2xl relative overflow-hidden ${
                      isProcessing ? 'bg-slate-800 text-white/50 cursor-not-allowed' : 'bg-primary-500 text-white hover:bg-primary-600'
                    }`}
                  >
                    {isProcessing ? (
                      <div className="flex items-center justify-center gap-4">
                        <div className="w-4 h-4 border-2 border-white/20 border-t-white rounded-full animate-spin" />
                        <span>Processing...</span>
                      </div>
                    ) : (
                      `Place Order - $${finalTotal.toFixed(2)}`
                    )}
                  </button>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Order Summary Sidebar - Responsive Positioning */}
          <div className="lg:col-span-1">
             <div className="sticky top-32 bg-white rounded-[2.5rem] md:rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-50 p-8 md:p-10">
                <h3 className="text-[10px] font-black uppercase tracking-[0.3em] text-slate-400 mb-8 px-2">Total Breakdown</h3>
                <div className="space-y-4 mb-8">
                   <div className="flex justify-between items-center text-[10px] font-bold text-slate-500 uppercase tracking-widest px-2">
                      <span>Subtotal</span>
                      <span className="text-slate-900">${totalPrice.toFixed(2)}</span>
                   </div>
                   <div className="flex justify-between items-center text-[10px] font-bold text-slate-500 uppercase tracking-widest px-2">
                      <span>Delivery Fee</span>
                      <span className="text-slate-900">${deliveryFee.toFixed(2)}</span>
                   </div>
                   <div className="flex justify-between items-center text-[10px] font-bold text-slate-500 uppercase tracking-widest px-2">
                      <span>Store Tax</span>
                      <span className="text-slate-900">${tax.toFixed(2)}</span>
                   </div>
                </div>
                <div className="h-px bg-slate-50 mb-8" />
                <div className="flex justify-between items-center px-2 mb-10">
                   <span className="text-[10px] font-black uppercase tracking-widest text-slate-900">Grand Total</span>
                   <span className="text-2xl md:text-3xl font-black text-primary-600 tracking-tighter">${finalTotal.toFixed(2)}</span>
                </div>
                
                <div className="bg-slate-50 p-6 rounded-2xl flex items-center gap-4">
                    <div className="w-10 h-10 bg-emerald-500 text-white rounded-xl flex items-center justify-center flex-shrink-0 animate-pulse">
                       <ShieldCheck size={20} />
                    </div>
                    <p className="text-[8px] font-black text-slate-400 uppercase tracking-widest leading-relaxed">
                       Secure encrypted checkout environment active.
                    </p>
                </div>
             </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default Checkout;