import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Truck, CheckCircle, Package, MapPin, ChefHat, Phone, Box, ChevronLeft, ArrowRight } from 'lucide-react';
import { motion } from 'framer-motion';

const OrderTracking: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const steps = [
    { title: 'Order Received', time: '11:45 PM', status: 'completed', icon: CheckCircle },
    { title: 'Preparing Food', time: '11:52 PM', status: 'current', icon: ChefHat },
    { title: 'On the Way', time: '12:15 AM', status: 'pending', icon: Truck },
    { title: 'Delivered', time: 'Pending', status: 'pending', icon: Package },
  ];

  return (
    <div className="bg-[#FAFAFA] min-h-screen pt-32 pb-32">
      <div className="container mx-auto px-4 max-w-4xl">
        
        <button onClick={() => navigate('/')} className="flex items-center gap-2 text-slate-400 hover:text-primary-500 transition-all mb-8 font-black uppercase text-[9px] tracking-widest">
           <ChevronLeft size={16} /> Dashboard
        </button>

        <div className="bg-white rounded-[2.5rem] md:rounded-[3.5rem] shadow-2xl shadow-slate-200/80 border border-slate-50 overflow-hidden">
          
          {/* Header - Mobile Responsive */}
          <div className="bg-slate-900 p-8 md:p-12 text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/10 blur-[100px] rounded-full" />
            <div className="relative z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-8">
               <div>
                  <span className="text-primary-500 font-black text-[9px] uppercase tracking-[0.4em] mb-4 block">Real-time Status</span>
                  <h1 className="text-3xl md:text-4xl font-black uppercase tracking-tighter mb-2">Order #{id}</h1>
                  <p className="text-slate-400 font-bold uppercase text-[9px] tracking-widest">The Gourmet Kitchen • 2 Specialized Items</p>
               </div>
               <div className="bg-white/5 backdrop-blur-3xl px-8 py-4 rounded-2xl border border-white/10 w-fit">
                  <p className="text-[8px] font-black uppercase tracking-widest text-primary-400 mb-1">Expected At</p>
                  <p className="text-2xl font-black tracking-tight">12:15 <span className="text-[10px] text-slate-400">AM</span></p>
               </div>
            </div>
          </div>

          {/* Tracking List - Scale adjustments */}
          <div className="p-8 md:p-16">
            <div className="space-y-0">
               {steps.map((step, idx) => (
                 <div key={idx} className="flex gap-6 md:gap-10 group">
                   <div className="flex flex-col items-center">
                     <div className={`w-12 h-12 md:w-14 md:h-14 rounded-2xl flex items-center justify-center transition-all duration-500 border-4 border-white shadow-xl ${
                       step.status === 'completed' ? 'bg-primary-500 text-white shadow-primary-500/30' : 
                       step.status === 'current' ? 'bg-slate-900 text-white animate-pulse' : 
                       'bg-slate-50 text-slate-200'
                     }`}>
                        <step.icon size={20} />
                     </div>
                     {idx < steps.length - 1 && (
                       <div className={`w-1 flex-grow my-4 rounded-full transition-all duration-1000 ${
                         step.status === 'completed' ? 'bg-primary-500' : 'bg-slate-100'
                       }`} />
                     )}
                   </div>
                   <div className="py-1 pb-12 md:pb-16 flex-grow">
                     <div className="flex items-center justify-between flex-wrap gap-2">
                        <h3 className={`text-lg md:text-xl font-black uppercase tracking-tight ${
                          step.status === 'pending' ? 'text-slate-200' : 'text-slate-900'
                        }`}>{step.title}</h3>
                        <p className={`text-[8px] font-black uppercase tracking-widest ${
                          step.status === 'completed' ? 'text-primary-500' : 'text-slate-400'
                        }`}>{step.time}</p>
                     </div>
                     
                     {step.status === 'current' && (
                       <motion.div 
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="mt-6 p-6 bg-slate-50 rounded-[1.5rem] md:rounded-[2rem] border border-slate-100 flex items-center gap-6"
                       >
                          <div className="w-10 h-10 md:w-12 md:h-12 bg-white rounded-xl shadow-sm flex items-center justify-center text-primary-500">
                             <ChefHat size={20} />
                          </div>
                          <div>
                             <p className="text-[8px] font-black uppercase tracking-widest text-slate-400 mb-1">Kitchen Update</p>
                             <p className="text-[10px] md:text-sm font-black text-slate-900 uppercase">Chef Marco is garnishing your meal.</p>
                          </div>
                       </motion.div>
                     )}
                   </div>
                 </div>
               ))}
            </div>
          </div>

          {/* Footer Info - Responsive buttons */}
          <div className="bg-slate-50 p-8 md:p-12 flex flex-col md:flex-row items-center justify-between gap-8 border-t border-slate-100">
             <div className="flex items-center gap-6 w-full md:w-auto">
                <div className="w-16 h-16 bg-white rounded-full border-4 border-white shadow-xl overflow-hidden ring-4 ring-primary-500/10 flex-shrink-0">
                   <img src="https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200" alt="Courier" className="w-full h-full object-cover" />
                </div>
                <div>
                   <p className="text-[8px] font-black uppercase tracking-widest text-slate-400 mb-1">Your Courier</p>
                   <p className="text-lg font-black text-slate-900 uppercase tracking-tight">Michael J.</p>
                   <div className="flex items-center text-amber-500 mt-1">
                      <CheckCircle size={10} className="mr-1" />
                      <span className="text-[8px] font-black uppercase">Top Professional</span>
                   </div>
                </div>
             </div>
             <div className="flex gap-4 w-full md:w-auto">
                <button className="flex-grow md:flex-none flex items-center justify-center gap-3 bg-white px-8 py-5 rounded-2xl text-slate-600 border border-slate-200 hover:text-primary-500 hover:border-primary-500 transition-all shadow-sm font-black uppercase text-[9px] tracking-widest">
                   <Phone size={18} /> Call Courier
                </button>
                <button className="flex-grow md:flex-none flex items-center justify-center bg-slate-900 text-white p-5 rounded-2xl hover:bg-primary-500 transition-all shadow-xl">
                   <Box size={20} />
                </button>
             </div>
          </div>

        </div>

        {/* Map Placeholder - Height adjustment */}
        <div className="mt-10 md:mt-12 w-full h-64 md:h-96 bg-slate-100 rounded-[2.5rem] md:rounded-[3.5rem] relative overflow-hidden shadow-2xl border-4 md:border-8 border-white group">
           <img src="https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&q=80&w=2000" className="w-full h-full object-cover opacity-30 grayscale" alt="Map" />
           <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 flex flex-col items-center gap-4">
              <div className="w-12 h-12 md:w-16 md:h-16 bg-primary-500 rounded-full flex items-center justify-center text-white shadow-2xl shadow-primary-500/50">
                <MapPin size={24} md:size={32} />
              </div>
              <p className="bg-slate-900/90 backdrop-blur-md text-white text-[8px] font-black uppercase tracking-widest px-6 py-3 rounded-full shadow-2xl">Courier is 1.2 miles away</p>
           </div>
        </div>

      </div>
    </div>
  );
};

export default OrderTracking;