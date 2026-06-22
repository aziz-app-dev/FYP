import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { ShoppingBag, User, Search, Menu, X, ChevronRight, MapPin } from 'lucide-react';
import { useCart } from '../../context/CartContext';
import { motion, AnimatePresence } from 'framer-motion';

const Navbar: React.FC = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { totalItems } = useCart();
  const location = useLocation();

  useEffect(() => {
    const handleScroll = () => setIsScrolled(window.scrollY > 20);
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  // Close mobile menu on route change
  useEffect(() => {
    setIsMobileMenuOpen(false);
  }, [location]);

  const navLinks = [
    { label: 'Home', path: '/' },
    { label: 'Menu', path: '/' },
    { label: 'Deals', path: '/' },
    { label: 'Orders', path: '/cart' },
  ];

  return (
    <nav className={`fixed top-0 left-0 right-0 z-[100] transition-all duration-500 px-4 py-4 md:px-8 md:py-6 ${
      isScrolled ? 'bg-white/80 backdrop-blur-2xl shadow-xl' : 'bg-transparent'
    }`}>
      <div className="container mx-auto flex items-center justify-between">
        
        {/* Mobile Menu Trigger */}
        <button 
          onClick={() => setIsMobileMenuOpen(true)}
          className="lg:hidden w-10 h-10 flex items-center justify-center text-slate-900 active:scale-95 transition-all"
        >
          <Menu size={24} />
        </button>

        {/* Logo */}
        <Link to="/" className="flex items-center gap-2 group">
           <div className="w-8 h-8 md:w-10 md:h-10 bg-primary-500 rounded-xl flex items-center justify-center text-white shadow-lg shadow-primary-500/30 group-hover:rotate-12 transition-transform">
              <span className="font-black text-xs md:text-sm italic">F</span>
           </div>
           <span className={`font-black text-lg md:text-2xl tracking-tighter uppercase transition-colors ${
             isScrolled ? 'text-slate-900' : 'text-white md:text-white lg:text-white'
           } ${location.pathname !== '/' ? 'text-slate-900' : ''}`}>FoodHub</span>
        </Link>

        {/* Desktop Navigation */}
        <div className={`hidden lg:flex items-center gap-10 px-8 py-3 rounded-full border transition-all ${
           isScrolled ? 'bg-slate-50 border-slate-100' : 'bg-white/10 border-white/10'
        }`}>
          {navLinks.map((link) => (
            <Link 
              key={link.label}
              to={link.path} 
              className={`text-[10px] font-black uppercase tracking-[0.2em] transition-colors hover:text-primary-500 ${
                isScrolled ? 'text-slate-600' : 'text-white'
              }`}
            >
              {link.label}
            </Link>
          ))}
        </div>

        {/* Actions */}
        <div className="flex items-center gap-2 md:gap-4">
           {/* Search - Hidden on tiny screens */}
           <button className={`hidden sm:flex items-center gap-3 px-6 py-3 rounded-2xl transition-all ${
              isScrolled ? 'bg-slate-50 text-slate-400' : 'bg-white/10 text-white/60'
           }`}>
             <Search size={16} />
             <span className="text-[10px] font-black uppercase tracking-widest">Search...</span>
           </button>

           <Link to="/cart" className="relative group">
              <div className={`w-10 h-10 md:w-12 md:h-12 rounded-2xl flex items-center justify-center shadow-lg transition-all active:scale-90 ${
                isScrolled ? 'bg-slate-900 text-white shadow-slate-900/20' : 'bg-white text-slate-900'
              }`}>
                 <ShoppingBag size={18} md:size={20} />
              </div>
              <AnimatePresence>
                {totalItems > 0 && (
                  <motion.span 
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    exit={{ scale: 0 }}
                    className="absolute -top-2 -right-2 bg-primary-500 text-white text-[8px] font-black w-5 h-5 md:w-6 md:h-6 flex items-center justify-center rounded-xl border-2 border-white lg:border-none shadow-lg"
                  >
                    {totalItems}
                  </motion.span>
                )}
              </AnimatePresence>
           </Link>

           <Link to="/profile" className="hidden md:flex">
              <div className={`w-12 h-12 rounded-2xl flex items-center justify-center border transition-all ${
                isScrolled ? 'border-slate-100 bg-white text-slate-400 hover:text-primary-500 hover:border-primary-100' : 'border-white/20 text-white/60 hover:text-white hover:border-white/40'
              }`}>
                 <User size={20} />
              </div>
           </Link>
        </div>
      </div>

      {/* Mobile Menu Overlay */}
      <AnimatePresence>
        {isMobileMenuOpen && (
          <>
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setIsMobileMenuOpen(false)}
              className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[110] lg:hidden"
            />
            <motion.div 
              initial={{ x: '-100%' }}
              animate={{ x: 0 }}
              exit={{ x: '-100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 200 }}
              className="fixed top-0 left-0 bottom-0 w-4/5 max-w-sm bg-white z-[120] lg:hidden p-8 flex flex-col shadow-2xl"
            >
               <div className="flex items-center justify-between mb-12">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 bg-primary-500 rounded-lg flex items-center justify-center text-white">
                      <span className="font-black text-xs italic">F</span>
                    </div>
                    <span className="font-black text-lg tracking-tighter uppercase text-slate-900">FoodHub</span>
                  </div>
                  <button onClick={() => setIsMobileMenuOpen(false)} className="w-10 h-10 bg-slate-50 rounded-xl flex items-center justify-center text-slate-400">
                    <X size={20} />
                  </button>
               </div>

               <div className="space-y-4 flex-grow">
                  {navLinks.map((link) => (
                    <Link 
                      key={link.label}
                      to={link.path}
                      className="block p-6 bg-slate-50 rounded-2xl group transition-all active:bg-primary-50"
                    >
                       <div className="flex items-center justify-between">
                          <span className="text-xs font-black uppercase tracking-[0.2em] text-slate-600 group-hover:text-primary-600">{link.label}</span>
                          <ChevronRight size={16} className="text-slate-300 group-hover:text-primary-400 group-hover:translate-x-1 transition-all" />
                       </div>
                    </Link>
                  ))}
               </div>

               <Link to="/profile" className="mt-8 p-6 border-2 border-dashed border-slate-100 rounded-3xl flex items-center gap-4 group">
                  <div className="w-12 h-12 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 group-hover:bg-primary-50 group-hover:text-primary-500 transition-colors">
                     <User size={20} />
                  </div>
                  <div>
                     <p className="text-[10px] font-black uppercase tracking-widest text-slate-900">Sign In</p>
                     <p className="text-[8px] font-bold uppercase tracking-widest text-slate-400">Premium Account</p>
                  </div>
               </Link>

               <div className="mt-8 pt-8 border-t border-slate-50">
                  <div className="flex items-center gap-4 text-slate-300 mb-6 px-4">
                     <MapPin size={14} />
                     <span className="text-[8px] font-black uppercase tracking-[0.3em]">Delivering to London, UK</span>
                  </div>
                  <p className="text-[8px] font-black uppercase tracking-[0.3em] text-slate-200 px-4">© 2024 FoodHub Premium</p>
               </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </nav>
  );
};

export default Navbar;