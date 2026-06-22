import React, { useState } from 'react';
import { Calendar, Users, Clock, ArrowRight, CheckCircle2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface ReservationModalProps {
  restaurant: any;
  isOpen: boolean;
  onClose: () => void;
}

const ReservationModal: React.FC<ReservationModalProps> = ({ restaurant, isOpen, onClose }) => {
  const [step, setStep] = useState(1);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setStep(2);
    setTimeout(onClose, 3000);
  };

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"
          onClick={onClose}
        />
        <motion.div 
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.95 }}
          className="bg-white w-full max-w-md rounded-[2.5rem] overflow-hidden shadow-2xl relative p-8"
        >
          {step === 1 ? (
            <>
              <div className="text-center mb-10">
                 <h3 className="text-2xl font-black uppercase tracking-tight mb-2">Book a Table</h3>
                 <p className="text-slate-500 text-sm">Secure your spot at <span className="text-primary-600 font-bold">{restaurant.title}</span></p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-6">
                 <div className="space-y-4">
                    <div className="relative">
                       <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                       <input 
                         type="date" 
                         required
                         className="w-full bg-slate-50 border border-slate-100 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 outline-none font-medium text-sm"
                       />
                    </div>
                    <div className="relative">
                       <Users className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                       <select className="w-full bg-slate-50 border border-slate-100 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 outline-none font-medium text-sm appearance-none">
                          <option>2 Guests</option>
                          <option>4 Guests</option>
                          <option>6 Guests</option>
                          <option>8+ Guests</option>
                       </select>
                    </div>
                    <div className="relative">
                       <Clock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                       <select className="w-full bg-slate-50 border border-slate-100 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 outline-none font-medium text-sm appearance-none">
                          <option>7:00 PM</option>
                          <option>7:30 PM</option>
                          <option>8:00 PM</option>
                          <option>8:30 PM</option>
                       </select>
                    </div>
                 </div>

                 <button className="w-full bg-slate-900 hover:bg-slate-800 text-white font-black py-4 rounded-2xl transition-all flex items-center justify-center uppercase tracking-widest text-xs">
                    Confirm Reservation
                    <ArrowRight size={16} className="ml-2" />
                 </button>
              </form>
            </>
          ) : (
            <div className="text-center py-10">
               <div className="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center text-white mx-auto mb-6 shadow-xl shadow-green-100">
                  <CheckCircle2 size={40} />
               </div>
               <h3 className="text-2xl font-black uppercase tracking-tight mb-2">Reserved!</h3>
               <p className="text-slate-500 text-sm">We've sent a confirmation email to you. See you soon!</p>
            </div>
          )}
        </motion.div>
      </div>
    </AnimatePresence>
  );
};

export default ReservationModal;
