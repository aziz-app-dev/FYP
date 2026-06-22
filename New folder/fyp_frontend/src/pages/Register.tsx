import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, User, Phone, ArrowRight } from 'lucide-react';
import { motion } from 'framer-motion';
import FoodPattern from '../components/layout/FoodPattern';

const Register: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-4 md:p-8 relative overflow-hidden">
      <FoodPattern />
      
      {/* Ambient Glow */}
      <div className="absolute top-1/2 -left-20 w-80 md:w-96 h-80 md:h-96 bg-primary-500/5 rounded-full blur-[120px]" />
      <div className="absolute top-0 right-0 w-64 md:w-80 h-64 md:h-80 bg-primary-600/5 rounded-full blur-[100px]" />

      <motion.div 
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        className="w-full max-w-xl bg-white/5 backdrop-blur-2xl border border-white/10 p-8 md:p-12 rounded-[2.5rem] md:rounded-[3rem] shadow-2xl relative z-10"
      >
        <div className="text-center mb-10">
          <h1 className="text-2xl md:text-3xl font-black text-white uppercase tracking-tight mb-2">Create Account</h1>
          <p className="text-slate-500 font-medium uppercase tracking-[0.2em] text-[8px] md:text-[9px]">Join our premium culinary community</p>
        </div>

        <form className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6" onSubmit={(e) => { e.preventDefault(); navigate('/'); }}>
          <div className="relative group">
            <User className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
            <input 
              type="text" 
              placeholder="FULL NAME" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[9px] md:text-[10px] uppercase tracking-widest placeholder:text-slate-700"
            />
          </div>

          <div className="relative group">
            <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
            <input 
              type="email" 
              placeholder="EMAIL ADDRESS" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[9px] md:text-[10px] uppercase tracking-widest placeholder:text-slate-700"
            />
          </div>

          <div className="relative group md:col-span-2">
            <Phone className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
            <input 
              type="tel" 
              placeholder="PHONE NUMBER" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[9px] md:text-[10px] uppercase tracking-widest placeholder:text-slate-700"
            />
          </div>

          <div className="relative group md:col-span-2">
            <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
            <input 
              type="password" 
              placeholder="SECURE PASSWORD" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[9px] md:text-[10px] uppercase tracking-widest placeholder:text-slate-700"
            />
          </div>

          <div className="md:col-span-2 pt-4">
            <button className="w-full bg-primary-500 hover:bg-primary-600 text-white font-black py-5 rounded-2xl transition-all shadow-xl shadow-primary-500/20 uppercase tracking-[0.3em] text-[9px] md:text-[10px] flex items-center justify-center gap-3">
              Start Your Journey <ArrowRight size={16} />
            </button>
          </div>
        </form>

        <p className="text-center mt-10 text-slate-600 font-bold uppercase tracking-widest text-[8px]">
          Already a member? <Link to="/login" className="text-white hover:text-primary-400 transition-colors ml-1 underline decoration-primary-500 underline-offset-4">Sign In</Link>
        </p>
      </motion.div>
    </div>
  );
};

export default Register;
