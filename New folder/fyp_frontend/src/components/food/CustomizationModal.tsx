import React from 'react';
import { X, Plus, Minus, Star, ShieldCheck } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface CustomizationModalProps {
  item: any;
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (item: any) => void;
}

const CustomizationModal: React.FC<CustomizationModalProps> = ({ item, isOpen, onClose, onConfirm }) => {
  const [quantity, setQuantity] = React.useState(1);

  if (!isOpen || !item) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
          className="absolute inset-0 bg-slate-900/60 backdrop-blur-md"
        />
        
        <motion.div 
          initial={{ opacity: 0, scale: 0.9, y: 20 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.9, y: 20 }}
          className="bg-white w-full max-w-xl rounded-[3.5rem] shadow-2xl relative z-10 overflow-hidden"
        >
          <button onClick={onClose} className="absolute top-6 right-6 w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-500 hover:bg-red-50 hover:text-red-500 transition-all">
            <X size={24} />
          </button>

          <div className="h-64 bg-slate-100 relative">
             <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
             <div className="absolute inset-0 bg-gradient-to-t from-white via-transparent to-transparent" />
          </div>

          <div className="p-10 -mt-12 relative z-20">
             <div className="flex items-center text-amber-500 mb-2">
                <Star size={12} className="fill-current mr-1.5" />
                <span className="text-[10px] font-black uppercase tracking-widest">{item.rating || '4.9'} Rated</span>
             </div>
             <h2 className="text-4xl font-black uppercase tracking-tighter text-slate-900 mb-4">{item.title}</h2>
             <p className="text-slate-500 text-sm font-medium leading-relaxed mb-10">{item.description}</p>

             <div className="space-y-8">
                <div className="flex items-center justify-between p-6 bg-slate-50 rounded-[2rem] border border-slate-100">
                   <span className="text-xs font-black uppercase tracking-widest text-slate-900">Quantity</span>
                   <div className="flex items-center gap-6">
                      <button onClick={() => setQuantity(Math.max(1, quantity - 1))} className="w-10 h-10 bg-white shadow-sm rounded-xl flex items-center justify-center text-slate-400 hover:text-primary-500 font-bold"><Minus size={16} /></button>
                      <span className="text-lg font-black text-slate-900">{quantity}</span>
                      <button onClick={() => setQuantity(quantity + 1)} className="w-10 h-10 bg-white shadow-sm rounded-xl flex items-center justify-center text-slate-400 hover:text-primary-500 font-bold"><Plus size={16} /></button>
                   </div>
                </div>

                <div className="p-6 border-2 border-dashed border-slate-200 rounded-[2.5rem] flex items-center justify-between text-slate-400 italic text-[10px] font-bold uppercase tracking-widest">
                   <span>No customizations available for this item</span>
                   <ShieldCheck size={20} className="text-slate-200" />
                </div>
             </div>

             <div className="mt-12 flex items-center justify-between gap-8 pt-8 border-t border-slate-100">
                <div>
                   <p className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1">Total Price</p>
                   <p className="text-3xl font-black text-slate-900">${(item.price * quantity).toFixed(2)}</p>
                </div>
                <button 
                  onClick={() => onConfirm({ ...item, quantity })}
                  className="bg-primary-500 hover:bg-primary-600 text-white px-12 py-5 rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-xl shadow-primary-500/30 transition-all active:scale-95"
                >
                  Confirm Order
                </button>
             </div>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
};

export default CustomizationModal;