import React from 'react';
import { Link } from 'react-router-dom';
import { ShoppingBag, Facebook, Twitter, Instagram, Youtube, Mail, Phone, MapPin } from 'lucide-react';

const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-slate-900 text-white pt-24 pb-12 overflow-hidden relative">
      {/* Decorative patterns */}
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary-500/10 blur-[120px] rounded-full -translate-y-1/2 translate-x-1/2" />
      <div className="absolute bottom-0 left-0 w-[300px] h-[300px] bg-primary-600/5 blur-[80px] rounded-full translate-y-1/2 -translate-x-1/2" />
      
      <div className="container mx-auto px-4 md:px-6 relative z-10">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-16 lg:gap-8 mb-20">
          
          {/* Brand Info */}
          <div className="space-y-8">
            <Link to="/" className="flex items-center gap-2 group">
              <div className="w-12 h-12 bg-primary-500 rounded-2xl flex items-center justify-center transform group-hover:rotate-[15deg] transition-all duration-300">
                <ShoppingBag className="text-white" size={24} />
              </div>
              <div>
                <span className="text-2xl font-black uppercase tracking-tighter">Food<span className="text-primary-500 italic">Hub</span></span>
                <p className="text-[8px] font-bold uppercase tracking-[0.3em] text-slate-500 -mt-1">Premium Delivery</p>
              </div>
            </Link>
            <p className="text-slate-400 text-sm leading-relaxed max-w-xs font-medium">
              Bringing the finest cuisine from top-tier restaurants directly to your doorstep with speed and elegance.
            </p>
            <div className="flex items-center gap-4">
              {[Facebook, Twitter, Instagram, Youtube].map((Icon, idx) => (
                <button key={idx} className="w-10 h-10 bg-white/5 border border-white/10 rounded-xl flex items-center justify-center text-white hover:bg-primary-500 hover:border-primary-500 transition-all group">
                  <Icon size={18} className="group-hover:scale-110 transition-transform" />
                </button>
              ))}
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-xs font-black uppercase tracking-[0.3em] text-primary-500 mb-8">Navigation</h4>
            <ul className="space-y-4">
              {['Home', 'Restaurants', 'Active Offers', 'How it works', 'Become a Partner'].map((item) => (
                <li key={item}>
                  <Link to="/" className="text-slate-400 hover:text-white transition-colors text-sm font-bold uppercase tracking-widest">{item}</Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Support */}
          <div>
            <h4 className="text-xs font-black uppercase tracking-[0.3em] text-primary-500 mb-8">Support</h4>
            <ul className="space-y-4">
              {['Contact Us', 'Help Center', 'Privacy Policy', 'Terms of Service', 'Cookie Policy'].map((item) => (
                <li key={item}>
                  <Link to="/" className="text-slate-400 hover:text-white transition-colors text-sm font-bold uppercase tracking-widest">{item}</Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact Info */}
          <div>
            <h4 className="text-xs font-black uppercase tracking-[0.3em] text-primary-500 mb-8">Contact Info</h4>
            <ul className="space-y-6">
              <li className="flex items-start gap-4">
                <div className="w-10 h-10 bg-primary-500/10 rounded-xl flex items-center justify-center text-primary-500 flex-shrink-0">
                  <MapPin size={18} />
                </div>
                <span className="text-slate-400 text-sm font-medium leading-relaxed">
                  123 Gourmet Street, Food Valley, <br /> CA 90210, United States
                </span>
              </li>
              <li className="flex items-center gap-4">
                <div className="w-10 h-10 bg-primary-500/10 rounded-xl flex items-center justify-center text-primary-500 flex-shrink-0">
                  <Phone size={18} />
                </div>
                <span className="text-slate-400 text-sm font-black tracking-widest">+1 (555) 987-6543</span>
              </li>
              <li className="flex items-center gap-4">
                <div className="w-10 h-10 bg-primary-500/10 rounded-xl flex items-center justify-center text-primary-500 flex-shrink-0">
                  <Mail size={18} />
                </div>
                <span className="text-slate-400 text-sm font-bold tracking-widest">hello@foodhub.com</span>
              </li>
            </ul>
          </div>

        </div>

        {/* Bottom Bar */}
        <div className="pt-12 border-t border-white/10 flex flex-col md:flex-row items-center justify-between gap-6">
          <p className="text-slate-500 text-[10px] font-black uppercase tracking-widest">
            © {currentYear} FoodHub. All rights reserved.
          </p>
          <div className="flex items-center gap-8">
            <Link to="/" className="text-slate-500 hover:text-slate-300 text-[10px] font-black uppercase tracking-widest">Privacy</Link>
            <Link to="/" className="text-slate-500 hover:text-slate-300 text-[10px] font-black uppercase tracking-widest">Terms</Link>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;