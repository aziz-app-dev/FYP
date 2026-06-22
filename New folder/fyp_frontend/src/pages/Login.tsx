import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, Eye, EyeOff, ArrowRight } from 'lucide-react';
import { motion } from 'framer-motion';
import FoodPattern from '../components/layout/FoodPattern';

const Login: React.FC = () => {
  const [showPassword, setShowPassword] = React.useState(false);
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-4 md:p-8 relative overflow-hidden">
      <FoodPattern />
      
      {/* Ambient Glow */}
      <div className="absolute top-1/4 -left-20 w-64 md:w-80 h-64 md:h-80 bg-primary-500/10 rounded-full blur-[100px]" />
      <div className="absolute bottom-1/4 -right-20 w-64 md:w-80 h-64 md:h-80 bg-primary-600/5 rounded-full blur-[100px]" />

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md bg-white/5 backdrop-blur-2xl border border-white/10 p-8 md:p-12 rounded-[2.5rem] md:rounded-[3rem] shadow-2xl relative z-10"
      >
        <div className="text-center mb-10">
          <div className="inline-block p-4 bg-primary-500 rounded-2xl mb-6 shadow-lg shadow-primary-500/30">
            <h2 className="text-white font-black text-xl md:text-2xl uppercase tracking-tighter">FoodHub</h2>
          </div>
          <h1 className="text-2xl md:text-3xl font-black text-white uppercase tracking-tight mb-2">Welcome Back</h1>
          <p className="text-slate-500 font-medium uppercase tracking-[0.2em] text-[8px] md:text-[9px]">Your premium dining experience awaits</p>
        </div>

        <form className="space-y-5 md:space-y-6" onSubmit={(e) => { e.preventDefault(); navigate('/'); }}>
          <div className="space-y-4">
            <div className="relative group">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
              <input 
                type="email" 
                placeholder="EMAIL ADDRESS" 
                className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[10px] md:text-xs uppercase tracking-widest placeholder:text-slate-700"
              />
            </div>
            
            <div className="relative group">
              <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-focus-within:text-primary-400 transition-colors" size={18} />
              <input 
                type={showPassword ? "text" : "password"} 
                placeholder="PASSWORD" 
                className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-12 focus:ring-2 focus:ring-primary-500 transition-all outline-none text-white font-bold text-[10px] md:text-xs uppercase tracking-widest placeholder:text-slate-700"
              />
              <button 
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-600 hover:text-white transition-colors"
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          <div className="flex justify-end">
            <Link to="/forgot-password" title="Forgot Password" className="text-primary-500 hover:text-primary-400 text-[8px] md:text-[9px] font-black uppercase tracking-widest transition-colors">Recover Access?</Link>
          </div>

          <button className="w-full bg-primary-500 hover:bg-primary-600 text-white font-black py-5 rounded-2xl transition-all shadow-xl shadow-primary-500/20 active:scale-[0.98] uppercase tracking-[0.3em] text-[9px] md:text-[10px] flex items-center justify-center gap-3">
            Sign In Now <ArrowRight size={16} />
          </button>
        </form>

        <p className="text-center mt-10 text-slate-600 font-bold uppercase tracking-widest text-[8px]">
          Don't have an account? <Link to="/register" className="text-white hover:text-primary-400 transition-colors ml-1 underline decoration-primary-500 underline-offset-4">Create One</Link>
        </p>
      </motion.div>
    </div>
  );
};

export default Login;
