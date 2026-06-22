import React, { useState } from 'react';
import { User as UserIcon, Settings, ShoppingBag, Heart, MapPin, LogOut, ChevronRight, CreditCard, ChevronLeft, Plus, Trash2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { useNavigate } from 'react-router-dom';

const Profile: React.FC = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'profile' | 'orders' | 'addresses' | 'favorites'>('profile');

  const orders = [
    { id: 'ORD-8829', restaurant: 'Tokyo Garden', date: 'Mar 22, 2026', total: 42.50, status: 'On the Way', items: 3 },
    { id: 'ORD-8820', restaurant: 'Burger King', date: 'Mar 18, 2026', total: 24.00, status: 'Delivered', items: 2 },
    { id: 'ORD-8712', restaurant: 'Pasta Bella', date: 'Mar 12, 2026', total: 56.20, status: 'Delivered', items: 4 },
  ];

  const addresses = [
    { id: 1, type: 'Home', address: '123 Luxury Avenue, Suite 402, New York, NY', isDefault: true },
    { id: 2, type: 'Office', address: '456 Business Park, Floor 12, New York, NY', isDefault: false },
  ];

  const menuItems = [
    { id: 'orders', icon: <ShoppingBag size={20} />, label: 'My Orders', description: 'Track and manage your orders' },
    { id: 'favorites', icon: <Heart size={20} />, label: 'Favorites', description: 'Quickly reorder your favorites' },
    { id: 'addresses', icon: <MapPin size={20} />, label: 'Addresses', description: 'Manage your delivery locations' },
    { icon: <CreditCard size={20} />, label: 'Payments', description: 'Manage cards and wallets' },
    { icon: <Settings size={20} />, label: 'Account Settings', description: 'Update profile and security' },
  ];

  const renderContent = () => {
    switch (activeTab) {
      case 'orders':
        return (
          <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="space-y-6">
            <h2 className="text-2xl font-black uppercase tracking-tighter text-slate-900 mb-8 flex items-center gap-4">
               <button onClick={() => setActiveTab('profile')} className="lg:hidden p-2 rounded-xl bg-slate-100"><ChevronLeft size={20}/></button>
               Order History
            </h2>
            {orders.map((order) => (
              <div key={order.id} className="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-sm hover:shadow-xl transition-all group">
                 <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
                    <div className="flex items-center gap-6">
                       <div className="w-14 h-14 bg-slate-50 rounded-2xl flex items-center justify-center text-primary-500 shadow-inner">
                          <ShoppingBag size={24} />
                       </div>
                       <div>
                          <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">{order.id}</p>
                          <h4 className="text-lg font-black text-slate-900 uppercase tracking-tight">{order.restaurant}</h4>
                          <p className="text-[9px] font-bold text-slate-500 uppercase tracking-widest mt-1">{order.date} • {order.items} Items</p>
                       </div>
                    </div>
                    <div className="flex flex-row sm:flex-col items-center sm:items-end justify-between sm:justify-center gap-2">
                       <span className={`px-4 py-1.5 rounded-full text-[8px] font-black uppercase tracking-widest ${
                         order.status === 'Delivered' ? 'bg-emerald-50 text-emerald-600' : 'bg-primary-50 text-primary-600 animate-pulse'
                       }`}>
                          {order.status}
                       </span>
                       <span className="text-xl font-black text-slate-900 tracking-tighter">${order.total.toFixed(2)}</span>
                    </div>
                 </div>
                 <div className="mt-6 pt-6 border-t border-slate-50 flex gap-4">
                    <button onClick={() => navigate(`/order-tracking/${order.id}`)} className="bg-slate-900 text-white px-6 py-3 rounded-xl font-black text-[9px] uppercase tracking-widest hover:bg-primary-500 transition-all">Reorder</button>
                    <button className="bg-slate-100 text-slate-600 px-6 py-3 rounded-xl font-black text-[9px] uppercase tracking-widest hover:bg-slate-200 transition-all">Details</button>
                 </div>
              </div>
            ))}
          </motion.div>
        );
      case 'addresses':
        return (
          <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="space-y-6">
            <div className="flex items-center justify-between mb-8">
               <h2 className="text-2xl font-black uppercase tracking-tighter text-slate-900 flex items-center gap-4">
                  <button onClick={() => setActiveTab('profile')} className="lg:hidden p-2 rounded-xl bg-slate-100"><ChevronLeft size={20}/></button>
                  Addresses
               </h2>
               <button className="bg-primary-500 text-white p-3 rounded-2xl shadow-lg shadow-primary-500/30 hover:bg-primary-600 transition-all"><Plus size={20}/></button>
            </div>
            {addresses.map((addr) => (
              <div key={addr.id} className={`bg-white p-8 rounded-[2.5rem] border ${addr.isDefault ? 'border-primary-500 shadow-xl' : 'border-slate-100 shadow-sm'} transition-all`}>
                 <div className="flex justify-between items-start mb-4">
                    <div className="flex items-center gap-4">
                       <MapPin className={addr.isDefault ? 'text-primary-500' : 'text-slate-400'} size={24} />
                       <h4 className="text-xl font-black text-slate-900 uppercase tracking-tight">{addr.type}</h4>
                       {addr.isDefault && <span className="bg-primary-500 text-white text-[7px] font-black px-3 py-1 rounded-full uppercase tracking-[0.2em]">Default</span>}
                    </div>
                    <div className="flex gap-2">
                       <button className="p-3 text-slate-300 hover:text-primary-500 transition-colors bg-slate-50 rounded-xl"><Plus size={16} /></button>
                       <button className="p-3 text-slate-300 hover:text-red-500 transition-colors bg-slate-50 rounded-xl"><Trash2 size={16} /></button>
                    </div>
                 </div>
                 <p className="text-slate-500 text-[10px] font-black uppercase tracking-widest leading-relaxed max-w-md">{addr.address}</p>
              </div>
            ))}
          </motion.div>
        );
      default:
        return (
          <div className="space-y-4">
            <h2 className="text-[10px] font-black uppercase tracking-[0.4em] text-slate-400 px-6 mb-8">Personal Manager</h2>
            {menuItems.map((item, idx) => (
              <motion.div 
                key={idx}
                whileHover={{ x: 10, scale: 1.01 }}
                onClick={() => item.id ? setActiveTab(item.id as any) : null}
                className="bg-white p-5 rounded-[2.5rem] border border-slate-50 shadow-sm hover:shadow-xl hover:border-primary-100 transition-all cursor-pointer flex items-center group"
              >
                <div className="w-12 h-12 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 group-hover:bg-primary-500 group-hover:text-white transition-all duration-500 mr-5 shadow-inner">
                  {item.icon}
                </div>
                <div className="flex-grow">
                  <h3 className="font-black text-slate-900 uppercase text-[10px] tracking-widest group-hover:text-primary-600 transition-colors">{item.label}</h3>
                  <p className="text-slate-400 text-[8px] uppercase font-bold tracking-widest mt-1 opacity-70 leading-relaxed">{item.description}</p>
                </div>
                <div className="w-8 h-8 bg-slate-50 rounded-full flex items-center justify-center text-slate-300 group-hover:text-primary-500 transition-colors">
                  <ChevronRight size={16} />
                </div>
              </motion.div>
            ))}
            <div className="pt-8">
              <button 
                onClick={() => navigate('/login')}
                className="w-full bg-slate-900 hover:bg-red-500 text-white font-black py-5 rounded-[2rem] transition-all flex items-center justify-center uppercase tracking-[0.3em] text-[9px] shadow-2xl group"
              >
                <LogOut size={16} className="mr-3 group-hover:-translate-x-1 transition-transform" /> 
                Sign Out from Account
              </button>
            </div>
          </div>
        );
    }
  };

  return (
    <div className="bg-[#FAFAFA] min-h-screen pt-32 pb-32">
      <div className="container mx-auto px-4 max-w-5xl">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          
          <div className="lg:col-span-4">
             <div className="sticky top-32 bg-white p-10 rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-50 text-center overflow-hidden relative">
                <div className="absolute top-0 left-0 w-full h-24 bg-primary-500/10" />
                <motion.div 
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  className="w-28 h-28 bg-white rounded-[2.5rem] mx-auto mb-6 flex items-center justify-center text-primary-600 border-8 border-white shadow-2xl relative z-10"
                >
                  <UserIcon size={56} className="opacity-80" />
                </motion.div>
                <h1 className="text-2xl font-black uppercase tracking-tight text-slate-900">Aziz Ahmad</h1>
                <p className="text-slate-400 font-bold uppercase tracking-widest text-[8px] mt-2 bg-slate-100 py-2 px-4 rounded-full inline-block">Premium Member</p>
                
                <div className="mt-8 pt-8 border-t border-slate-50 grid grid-cols-2 gap-4">
                   <div onClick={() => setActiveTab('orders')} className="text-center cursor-pointer group">
                      <p className="text-xl font-black text-slate-900 group-hover:text-primary-500 transition-colors">42</p>
                      <p className="text-[7px] font-black uppercase tracking-widest text-slate-400">Orders</p>
                   </div>
                   <div className="text-center">
                      <p className="text-xl font-black text-primary-500">12</p>
                      <p className="text-[7px] font-black uppercase tracking-widest text-slate-400">Reviews</p>
                   </div>
                </div>
                
                {activeTab !== 'profile' && (
                  <button 
                    onClick={() => setActiveTab('profile')}
                    className="mt-8 w-full bg-slate-50 text-slate-400 py-3 rounded-xl font-black text-[8px] uppercase tracking-widest hover:bg-slate-100 transition-all flex items-center justify-center gap-2"
                  >
                     <ChevronLeft size={12} /> Dashboard Menu
                  </button>
                )}
             </div>
          </div>

          <div className="lg:col-span-8">
             <AnimatePresence mode="wait">
                {renderContent()}
             </AnimatePresence>
          </div>
          
        </div>
      </div>
    </div>
  );
};

export default Profile;
